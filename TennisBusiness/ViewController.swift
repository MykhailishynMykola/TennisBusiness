//
//  ViewController.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    private var database: Firestore!
    private var expectedWorldsCount: Int = 0
    
    private var worlds: [String: World] = [:] {
        didSet {
            guard worlds.count == expectedWorldsCount else {
                return
            }
            loadMatches()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        
        database.collection("worlds").getDocuments { [weak self] (worldsSnapshot, error) in
            guard let worldDocuments = worldsSnapshot?.documents,
                error == nil else {
                return
            }
            self?.expectedWorldsCount = worldDocuments.count
            for worldDocument in worldDocuments {
                guard worldDocument.exists else { return }
                let worldIdentifier = worldDocument.documentID
                let worldData = worldDocument.data()
                guard let speed = worldData["speed"] as? Double,
                    let createdAt = worldData["createdAt"] as? Timestamp else {
                        return
                }
                let playersReference = self?.database.collection("worlds").document(worldDocument.documentID).collection("players")
                playersReference?.getDocuments { [weak self] (playerSnapshot, error) in
                    guard let playerDocuments = playerSnapshot?.documents,
                        error == nil else {
                        return
                    }
                    var players: [String: Player] = [:]
                    for playerDocument in playerDocuments {
                        guard playerDocument.exists,
                            let player = Player(snapshot: playerDocument) else {
                                return
                        }
                        players[playerDocument.documentID] = player
                    }
                    let newWorld = World(identifier: worldIdentifier,
                                         speed: speed,
                                         createdAt: createdAt.dateValue(),
                                         players: players)
                    self?.worlds[worldIdentifier] = newWorld
                }
            }
        }
    }
    
    
    
    // MARK: - Private
    
    private func loadMatches() {
        for (identifier, world) in worlds {
            database.collection("worlds").document(identifier).collection("matches").getDocuments { (matchesSnapshot, error) in
                guard let matchDocuments = matchesSnapshot?.documents else {
                    return
                }
                var matches: [String: Match] = [:]
                for matchDocument in matchDocuments {
                    let matchData = matchDocument.data()
                    guard let matchIdentifier = matchData["identifier"] as? String,
                        let setsToWin = matchData["setsToWin"] as? Int,
                        let player1Identifier = matchData["player1"] as? String,
                        let player2Identifier = matchData["player2"] as? String,
                        let player1 = world.players[player1Identifier],
                        let player2 = world.players[player2Identifier] else {
                            return
                    }
                    let newMatch = Match(identifier: matchIdentifier, firstPlayer: player1, secondPlayer: player2, setsToWin: setsToWin)
                    matches[matchDocument.documentID] = newMatch
                }
                world.add(matches: matches)
            }
        }
    }
}

