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
    let name: String
    let speed: Double
    let createdAt: Date
    var players: [Player]
    var matches: [Match] = [] {
        didSet {
            let matchesToCalculation = matches.filter { !$0.isFinished }
            matchesToCalculation.forEach { match in
                while !match.isFinished {
                    match.handleNext()
                }
            }
        }
    }
    
    var currentWorldDate: Date {
        let currentDate = Date()
        let diff = currentDate.timeIntervalSince(createdAt)
        return createdAt + diff * speed
    }
    
    
    
    // MARK: - Init
    
    init(identifier: String, name: String, speed: Double, createdAt: Date, players: [Player]) {
        self.identifier = identifier
        self.name = name
        self.speed = speed
        self.createdAt = createdAt
        self.players = players
    }
}



// MARK: - Equatable
func == (lhs: World, rhs: World) -> Bool {
    return lhs.identifier == rhs.identifier
        && lhs.speed == rhs.speed
        && lhs.createdAt == rhs.createdAt
}



// MARK: - Hashable
extension World: Hashable {
    var hashValue: Int {
        return "\(identifier)-\(speed)-\(createdAt)".hashValue
    }
}
