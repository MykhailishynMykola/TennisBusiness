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
    
    private var matches: [Match] = []
    
    
    
    // MARK: - Init
    
    init() {
        Timer.every(0.1) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.matches.forEach { match in
                guard !match.isFinished else { return }
                match.handleNext()
            }
        }
    }
    
    
    
    // MARK: - Public
    
    func add(matches: [Match]) {
        self.matches.append(contentsOf: matches)
    }
}
