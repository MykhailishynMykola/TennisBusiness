//
//  DataManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/12/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import PromiseKit
import FirebaseFirestore
import Swinject

protocol DataManager {
    func getWorlds() -> Promise<[World]>
    
    func createPlayer(with name: String, surname: String, country: Country, ability: Ability, worldIdentifier: String) -> Promise<Player>
    func createMatch(firstPlayer: Player, secondPlayer: Player, setsToWin: Int, date: Date, worldIdentifier: String, country: Country?) -> Promise<Match>
    
    func setMatchResult(_ match: Match, worldIdentifier: String) -> Promise<Void>
    func addTournaments(_ tournamentsData: [TournamentData], worldIdentifier: String) -> Promise<[Tournament]>
}



final class DataManagerImp: DataManager, ResolverInitializable {
    // MARK: - Properties
    
    private let countriesDataManager: CountriesDataManager
    
    
    
    // MARK: - Init
    
    init(countriesDataManager: CountriesDataManager) {
        self.countriesDataManager = countriesDataManager
    }
    
    
    
    // MARK: - ResolverInitializable
    
    convenience init?(resolver: Resolver) {
        guard let countriesDataManager = resolver.resolve(CountriesDataManager.self) else {
            print("Warning: Failed to initilize all needed dependencies!")
            return nil
        }
        self.init(countriesDataManager: countriesDataManager)
    }
    
    
    
    // MARK: - DataManager
    
    func getWorlds() -> Promise<[World]> {
        return loadWorlds()
    }
    
    func createPlayer(with name: String, surname: String, country: Country, ability: Ability, worldIdentifier: String) -> Promise<Player> {
        let abilityData: [String: Any] = ["skill": ability.skill.doubleValue,
                                          "serve": ability.serve.doubleValue,
                                          "return": ability.returnOfServe.doubleValue,
                                          "countryBonus": ability.countryBonus.doubleValue]
        let newPlayerData: [String: Any] = ["name": name,
                                            "surname": surname,
                                            "countryCode": country.code,
                                            "ability": abilityData]
        return Promise(resolvers: { (fulfill, reject) in
            var newPlayerReference: DocumentReference? = nil
            newPlayerReference = database.collection("worlds")
                .document(worldIdentifier)
                .collection("players")
                .addDocument(data: newPlayerData) { error in
                    guard error == nil,
                        let newPlayerIdentifier = newPlayerReference?.documentID else {
                            print("Error: Failed to create a new player.")
                            if let error = error { reject(error) }
                            return
                    }
                    let newPlayer = Player(identifier: newPlayerIdentifier, name: name, surname: surname, ability: ability, country: country)
                    fulfill(newPlayer)
            }
        })
    }
    
    func createMatch(firstPlayer: Player, secondPlayer: Player, setsToWin: Int, date: Date, worldIdentifier: String, country: Country?) -> Promise<Match> {
        let newMatchData: [String: Any] = ["player1": firstPlayer.identifier,
                                           "player2": secondPlayer.identifier,
                                           "setsToWin": setsToWin,
                                           "eventDate": Timestamp(date: date),
                                           "result": "",
                                           "countryCode": country?.code ?? ""]
        return Promise(resolvers: { (fulfill, reject) in
            var newMatchReference: DocumentReference? = nil
            newMatchReference = database.collection("worlds")
                .document(worldIdentifier)
                .collection("matches")
                .addDocument(data: newMatchData) { error in
                    guard error == nil,
                        let newMatchIdentifier = newMatchReference?.documentID else {
                            print("Error: Failed to create a new match.")
                            if let error = error { reject(error) }
                            return
                    }
                    let newMatch = Match(identifier: newMatchIdentifier,
                                         firstPlayer: firstPlayer,
                                         secondPlayer: secondPlayer,
                                         setsToWin: setsToWin,
                                         eventDate: date,
                                         result: "",
                                         country: country)
                    fulfill(newMatch)
            }
        })
    }
    
    func setMatchResult(_ match: Match, worldIdentifier: String) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            let matchReference: DocumentReference = database.collection("worlds")
                .document(worldIdentifier)
                .collection("matches")
                .document(match.identifier)
            let data: [String: Any] = ["result": match.result]
            return matchReference.setData(data, merge: true, completion: { error in
                if let error = error {
                    reject(error)
                    return
                }
                fulfill(())
            })
        })
    }
    
    func addTournaments(_ tournamentsData: [TournamentData], worldIdentifier: String) -> Promise<[Tournament]> {
        let promises: [Promise<Tournament>] = tournamentsData.map { tournamentData -> Promise<Tournament> in
            let tournamentsRaw: [String: Any] = ["name": tournamentData.name,
                                                 "city": tournamentData.city,
                                                 "countryCode": tournamentData.country?.code ?? "",
                                                 "week": tournamentData.week,
                                                 "surface": tournamentData.surface.rawValue,
                                                 "surfaceType": tournamentData.surfaceType.rawValue,
                                                 "totalFinancialCommitment": tournamentData.totalFinancialCommitment,
                                                 "points": tournamentData.points.rawValue,
                                                 "drawSingle": tournamentData.draw.single,
                                                 "drawDouble": tournamentData.draw.double,
                                                 "startDate": Timestamp(date: tournamentData.startDate)]
            return Promise(resolvers: { (fulfill, reject) in
                var newTournamentReference: DocumentReference? = nil
                newTournamentReference = database.collection("worlds")
                    .document(worldIdentifier)
                    .collection("tournaments")
                    .addDocument(data: tournamentsRaw) { error in
                        guard error == nil,
                            let newTournamentIdentifier = newTournamentReference?.documentID else {
                                print("Error: Failed to create a new tournament.")
                                if let error = error { reject(error) }
                                return
                        }
                        let newTournament = Tournament(identifier: newTournamentIdentifier,
                                                       name: tournamentData.name,
                                                       city: tournamentData.city,
                                                       country: tournamentData.country,
                                                       week: tournamentData.week,
                                                       surface: tournamentData.surface,
                                                       surfaceType: tournamentData.surfaceType,
                                                       totalFinancialCommitment: tournamentData.totalFinancialCommitment,
                                                       points: tournamentData.points,
                                                       draw: tournamentData.draw,
                                                       startDate: tournamentData.startDate)
                        fulfill(newTournament)
                }
            })
        }
        return collectSuccesses(promises)
    }
    
    
    
    // MARK: - Private
    
    private func loadWorlds() -> Promise<[World]> {
        return Promise(resolvers: { (fulfill, reject) in
            let collectionReference: CollectionReference = database.collection("worlds")
            collectionReference.getDocuments { (worldsSnapshot, error) in
                if let error = error {
                    return reject(error)
                }
                guard let worldDocuments = worldsSnapshot?.documents else {
                    return reject(NSError.cancelledError())
                }
                fulfill(worldDocuments)
            }
        })
            .then { [weak self] (worldDocuments: [QueryDocumentSnapshot]) -> Promise<[World]> in
                guard let `self` = self else { throw NSError.cancelledError() }
                var worldPromises: [Promise<World>] = []
                for worldDocument in worldDocuments {
                    worldPromises.append(self.loadWorld(from: worldDocument))
                }
                return collectSuccesses(worldPromises)
            }
            .then { worlds -> Promise<[World]> in
                return Promise(value: worlds)
        }
    }
    
    private func loadWorld(from document: QueryDocumentSnapshot) -> Promise<World> {
        let worldIdentifier = document.documentID
        return loadPlayers(from: document)
            .then { [weak self] players -> Promise<(matches: [Match], players: [Player])> in
                guard let `self` = self else { throw NSError.cancelledError() }
                return self.loadMatches(forWorldIdentifier: worldIdentifier, players: players)
                    .then { matches -> Promise<(matches: [Match], players: [Player])> in
                        return Promise(value: (matches, players))
                }
            }
            .then { [weak self] matches, players -> Promise<(matches: [Match], players: [Player], tournaments: [Tournament])> in
                guard let `self` = self else { throw NSError.cancelledError() }
                return self.loadTournaments(forWorldIdentifier: worldIdentifier)
                    .then { tournaments -> Promise<(matches: [Match], players: [Player], tournaments: [Tournament])> in
                        return Promise(value: (matches, players, tournaments))
                }
            }
            .then { matches, players, tournaments -> Promise<World> in
                let worldData = document.data()
                guard let speed = worldData["speed"] as? Double,
                    let createdAt = worldData["createdAt"] as? Timestamp,
                    let name = worldData["name"] as? String else {
                        throw NSError.cancelledError()
                }
                let newWorld = World(identifier: worldIdentifier,
                                     name: name,
                                     speed: speed,
                                     createdAt: createdAt.dateValue(),
                                     players: players,
                                     matches: matches,
                                     tournaments: tournaments)
                return Promise(value: newWorld)
        }
    }
    
    private func loadPlayers(from document: QueryDocumentSnapshot) -> Promise<[Player]> {
        return Promise(resolvers: { (fulfill, reject) in
            guard document.exists else { throw NSError.cancelledError() }
            let playersReference = database
                .collection("worlds")
                .document(document.documentID)
                .collection("players")
            playersReference.getDocuments { (playerSnapshot, error) in
                if let error = error {
                    return reject(error)
                }
                guard let playerDocuments = playerSnapshot?.documents else {
                    return reject(NSError.cancelledError())
                }
                fulfill(playerDocuments)
            }
        })
            .then { [weak self] (playerDocuments: [QueryDocumentSnapshot]) -> Promise<[Player]> in
                guard let `self` = self else { throw NSError.cancelledError() }
                var playerPromises: [Promise<Player>] = []
                for playerDocument in playerDocuments {
                    playerPromises.append(self.loadPlayer(from: playerDocument))
                }
                return collectSuccesses(playerPromises)
        }
    }
    
    private func loadPlayer(from document: QueryDocumentSnapshot) -> Promise<Player> {
        return Promise(resolvers: { (fulfill, reject) in
            guard document.exists,
                let player = Player(snapshot: document, countries: countriesDataManager.countries) else {
                    return reject(NSError.cancelledError())
            }
            fulfill(player)
        })
    }
    
    private func loadMatches(forWorldIdentifier identifier: String, players: [Player]) -> Promise<[Match]> {
        return Promise(resolvers: { (fulfill, reject) in
            database
                .collection("worlds")
                .document(identifier)
                .collection("matches")
                .getDocuments { (matchesSnapshot, error) in
                    guard let matchDocuments = matchesSnapshot?.documents else {
                        return reject(NSError.cancelledError())
                    }
                    let matches = matchDocuments.compactMap { Match(snapshot: $0, players: players, countries: self.countriesDataManager.countries) }
                    fulfill(matches)
            }
        })
    }
    
    private func loadTournaments(forWorldIdentifier identifier: String) -> Promise<[Tournament]> {
        return Promise(resolvers: { (fulfill, reject) in
            database
                .collection("worlds")
                .document(identifier)
                .collection("tournaments")
                .getDocuments { (tournamentSnapshot, error) in
                    guard let tournamentDocuments = tournamentSnapshot?.documents else {
                        return reject(NSError.cancelledError())
                    }
                    let tournaments = tournamentDocuments.compactMap { Tournament(snapshot: $0, countries: self.countriesDataManager.countries) }
                    fulfill(tournaments)
            }
        })
    }
}
