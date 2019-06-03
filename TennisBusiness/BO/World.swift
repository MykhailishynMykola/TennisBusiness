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
    private var matches: [String: Match] = [:]
    private var timer: Timer?
    
    
    
    // MARK: - Init
    
    init(identifier: String, speed: Double, createdAt: Date, players: [String: Player]) {
        self.identifier = identifier
        self.speed = speed
        self.createdAt = createdAt
        self.players = players
        timer = Timer.every(0.1) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.matches.forEach { _, match in
                guard !match.isFinished else { return }
                match.handleNext()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    // MARK: - Public
    
    func add(matches: [String: Match]) {
        self.matches.merge(matches) { (current, _) in current }
    }
}
