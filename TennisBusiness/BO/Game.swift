//
//  Game.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Game {
    // MARK: - Properties
    
    var status: Status = .inProgress
    var points: (Point, Point) = (.zero, .zero)
    var tiebreakPoints: (Int, Int) = (0, 0)
    var identifier: Int
    var isTiebreak: Bool
    
    
    
    // MARK: - Init
    
    init(identifier: Int, isTiebreak: Bool) {
        self.identifier = identifier
        self.isTiebreak = isTiebreak
    }
}


