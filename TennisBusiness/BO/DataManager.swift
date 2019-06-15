//
//  DataManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/12/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import PromiseKit
import FirebaseFirestore

protocol DataManager {
    func getWorlds() -> Promise<[World]>
}



class DataManagerImp: DataManager {
    // MARK: - DataManager
    
    func getWorlds() -> Promise<[World]> {
        return loadWorlds()
            .then { [weak self] worlds -> Promise<[World]> in
                guard let `self` = self else { throw NSError.cancelledError() }
                for world in worlds {
                    self.loadMatches(for: world).then { matches -> Void in
                        world.matches.append(contentsOf: matches)
                    }
                }
                return Promise(value: worlds)
        }
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
            .then { players -> Promise<World> in
                let worldIdentifier = document.documentID
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
                                     players: players)
                return Promise(value: newWorld)
        }
    }
    
    private func loadPlayer(from document: QueryDocumentSnapshot) -> Promise<Player> {
        return Promise(resolvers: { (fulfill, reject) in
            guard document.exists,
                let player = Player(snapshot: document) else {
                    return reject(NSError.cancelledError())
            }
            fulfill(player)
        })
    }
    
    private func loadMatches(for world: World) -> Promise<[Match]> {
        return Promise(resolvers: { (fulfill, reject) in
            database
                .collection("worlds")
                .document(world.identifier)
                .collection("matches")
                .getDocuments { (matchesSnapshot, error) in
                    guard let matchDocuments = matchesSnapshot?.documents else {
                        return reject(NSError.cancelledError())
                    }
                    let matches = matchDocuments.compactMap { Match(snapshot: $0, world: world) }
                    fulfill(matches)
            }
        })
    }
}
