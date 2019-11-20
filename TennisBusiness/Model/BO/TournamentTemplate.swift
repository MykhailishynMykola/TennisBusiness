//
//  TournamentTemplate.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 9/29/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class TournamentTemplate {
    // MARK: - Properties
    
    let name: String
    let city: String
    let country: Country?
    let week: Int
    let surface: Surface
    let surfaceType: SurfaceLocationType
    let totalFinancialCommitment: Double
    let points: TournamentPoints
    let draw: (single: Int, double: Int)
    
    private let start: (month: Int, day: Int)
    
    
    
    // MARK: - Init
    
    init(name: String, city: String, country: Country?,
         start: (month: Int, day: Int),
         week: Int, surface: Surface,
         surfaceType: SurfaceLocationType,
         totalFinancialCommitment: Double, points: TournamentPoints,
         draw: (single: Int, double: Int)) {
        self.name = name
        self.city = city
        self.country = country
        self.start = start
        self.week = week
        self.surface = surface
        self.surfaceType = surfaceType
        self.totalFinancialCommitment = totalFinancialCommitment
        self.points = points
        self.draw = draw
    }
}
