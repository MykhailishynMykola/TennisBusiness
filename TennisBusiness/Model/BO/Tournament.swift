//
//  Tournament.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 9/29/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class Tournament {
    // MARK: - Inner
    
    enum Points: Int {
        case nextGen = 0
        case atp250 = 250
        case atp500 = 500
        case atp1000 = 1000
        case atpFinals = 1500
        case grandSlam = 2000
    }
    
    
    
    // MARK: - Properties
    
    let name: String
    let city: String
    let country: Country?
    let start: (month: Int, day: Int)
    let surface: Surface
    let surfaceType: SurfaceLocationType
    let totalFinancialCommitment: Double
    let points: Points
    let draw: (single: Int, double: Int)
    
    
    
    // MARK: - Init
    
    init(name: String, city: String, country: Country?,
         start: (month: Int, day: Int), surface: Surface,
         surfaceType: SurfaceLocationType,
         totalFinancialCommitment: Double, points: Points,
         draw: (single: Int, double: Int)) {
        self.name = name
        self.city = city
        self.country = country
        self.start = start
        self.surface = surface
        self.surfaceType = surfaceType
        self.totalFinancialCommitment = totalFinancialCommitment
        self.points = points
        self.draw = draw
    }
}
