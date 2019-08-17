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
    let identifier: Int
    var isTiebreak: Bool
    let serveTurn: ServeTurn
    
    
    
    // MARK: - Init
    
    init(identifier: Int, isTiebreak: Bool, serveTurn: ServeTurn) {
        self.identifier = identifier
        self.isTiebreak = isTiebreak
        self.serveTurn = serveTurn
    }
}


