//
//  TournamentPoints.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 11/3/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

enum TournamentPoints: String {
    case nextGen
    case atp250
    case atp500
    case atp1000
    case atpFinals
    case grandSlam
    
    var value: Int {
        switch self {
        case .nextGen:
            return 0
        case .atp250:
            return 250
        case .atp500:
            return 500
        case .atp1000:
            return 1000
        case .atpFinals:
            return 1500
        case .grandSlam:
            return 2000
        }
    }
}
