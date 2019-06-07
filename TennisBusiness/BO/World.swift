//
//  World.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class World {
    // MARK: - Properties
    
    let identifier: String
    let players: [String: Player]
    private let speed: Double
    private let createdAt: Date
    private var matches: [String: Match] = [:] {
        didSet {
            let matchesToCalculation = matches.filter { !$0.value.isFinished }
            matchesToCalculation.forEach { _, match in
                while !match.isFinished {
                    match.handleNext()
                }
            }
        }
    }
    
    
    
    // MARK: - Init
    
    init(identifier: String, speed: Double, createdAt: Date, players: [String: Player]) {
        self.identifier = identifier
        self.speed = speed
        self.createdAt = createdAt
        self.players = players
    }
    
    
    
    // MARK: - Public
    
    func add(matches: [String: Match]) {
        self.matches.merge(matches) { (current, _) in current }
    }
}
