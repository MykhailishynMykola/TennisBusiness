//
//  CalculationManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/16/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation
import Swinject

protocol CalculationManager {
    func start(with worlds: [World])
}

final class CalculationManagerImp: CalculationManager, ResolverInitializable {
    // MARK: - Inner
    
    private struct Constants {
        static let calculationTimeBeforeMatch: TimeInterval = 3 * 60 // 3 min
    }
    
    
    
    // MARK: - Properties
    
    private var worlds: [World] = []
    private var timer: Timer?
    private let dataManager: DataManager
    
    
    
    // MARK: - Init
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    
    
    // MARK: - ResolverInitializable
    
    convenience init?(resolver: Resolver) {
        guard let dataManager = resolver.resolve(DataManager.self) else {
            print("Warning: Failed to initilize all needed dependencies!")
            return nil
        }
        self.init(dataManager: dataManager)
    }
    
    
    
    // MARK: - Public
    
    func start(with worlds: [World]) {
        self.worlds = worlds
        timer = Timer.every(1) { [weak self] in
            guard let `self` = self else { return }
            for world in self.worlds {
                self.check(world)
            }
        }
    }
    
    
    
    // MARK: - Private
    
    private func check(_ world: World) {
        let unfinishedMatches = world.matches.filter { !$0.isFinished }
        for match in unfinishedMatches {
            let diff = match.eventDate.timeIntervalSince(world.currentWorldDate)
            let timeBeroreCalculation = Constants.calculationTimeBeforeMatch * world.speed
            if diff < timeBeroreCalculation  {
                match.calculateResult()
                dataManager.setMatchResult(match, worldIdentifier: world.identifier)
                    .catch { _ in }
            }
        }
    }
}
