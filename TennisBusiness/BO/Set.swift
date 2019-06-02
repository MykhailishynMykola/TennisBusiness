//
//  Set.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Set {
    // MARK: - Properties
    
    var identifier: Int
    var status: Status = .inProgress
    var points: (Int, Int) = (0, 0)
    var games: [Game] = [Game(identifier: 1, isTiebreak: false)]
    
    var gamesFirstWin: Int {
        return games.filter { $0.status == .firstWin }.count
    }
    
    var gamesSecondWin: Int {
        return games.filter { $0.status == .secondWin }.count
    }
    
    
    // MARK: - Init
    
    init(identifier: Int) {
        self.identifier = identifier
    }
}
