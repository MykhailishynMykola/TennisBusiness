//
//  ServeTurn.swift
//  TennisBusiness
//
//  Created by user on 6/2/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

enum ServeTurn {
    case firstPlayer
    case firstPlayerNextServe
    case secondPlayer
    case secondPlayerNextServe
    
    var isFirstPlayerServe: Bool {
        return self == .firstPlayer || self == .firstPlayerNextServe
    }
    
    func next(isTiebreak: Bool) -> ServeTurn {
        guard isTiebreak else {
            return self == .firstPlayer ? .secondPlayer : .firstPlayer
        }
        switch self {
        case .firstPlayer:
            return .firstPlayerNextServe
        case .firstPlayerNextServe:
            return .secondPlayer
        case .secondPlayer:
            return .secondPlayerNextServe
        case .secondPlayerNextServe:
            return .firstPlayer
        }
    }
}
