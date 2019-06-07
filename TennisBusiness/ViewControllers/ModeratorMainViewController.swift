//
//  ModeratorMainViewController.swift
//  TennisBusiness
//
//  Created by user on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ModeratorMainViewController: ScreenViewController {
    // MARK: - Properties
    
    private var expectedWorldsCount: Int = 0
    
    private var worlds: [String: World] = [:] {
        didSet {
            guard worlds.count == expectedWorldsCount else {
                return
            }
            parseMatches()
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    
    // MARK: - Private
    
    private func loadData() {
        database.collection("worlds").getDocuments { [weak self] (worldsSnapshot, error) in
            guard let worldDocuments = worldsSnapshot?.documents,
                error == nil else {
                    return
            }
            self?.expectedWorldsCount = worldDocuments.count
            for worldDocument in worldDocuments {
                self?.parseWorld(worldDocument)
            }
        }
    }
    
    private func parseWorld(_ document: QueryDocumentSnapshot) {
        guard document.exists else { return }
        let worldIdentifier = document.documentID
        let worldData = document.data()
        guard let speed = worldData["speed"] as? Double,
            let createdAt = worldData["createdAt"] as? Timestamp else {
                return
        }
        let playersReference = database.collection("worlds").document(document.documentID).collection("players")
        playersReference.getDocuments { [weak self] (playerSnapshot, error) in
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
    
    private func parseMatches() {
        for (identifier, world) in worlds {
            database.collection("worlds").document(identifier).collection("matches").getDocuments { (matchesSnapshot, error) in
                guard let matchDocuments = matchesSnapshot?.documents else {
                    return
                }
                var matches: [String: Match] = [:]
                for matchDocument in matchDocuments {
                    guard let newMatch = Match(snapshot: matchDocument, world: world) else {
                        return
                    }
                    matches[matchDocument.documentID] = newMatch
                }
                world.add(matches: matches)
            }
        }
    }
}
