//
//  TournamentData.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 11/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

// Subsidiary struct for convenience
struct TournamentData {
    let name: String
    let city: String
    let country: Country?
    let week: Int
    let surface: Surface
    let surfaceType: SurfaceLocationType
    let totalFinancialCommitment: Double
    let points: TournamentPoints
    let draw: (single: Int, double: Int)
    let startDate: Date
    
    init(name: String, city: String, country: Country?, week: Int, surface: Surface, surfaceType: SurfaceLocationType, totalFinancialCommitment: Double, points: TournamentPoints, draw: (single: Int, double: Int), startDate: Date) {
        self.name = name
        self.city = city
        self.country = country
        self.week = week
        self.surface = surface
        self.surfaceType = surfaceType
        self.totalFinancialCommitment = totalFinancialCommitment
        self.points = points
        self.draw = draw
        self.startDate = startDate
    }
    
    init(template: TournamentTemplate, startDate: Date) {
        self.init(name: template.name,
                  city: template.city,
                  country: template.country,
                  week: template.week,
                  surface: template.surface,
                  surfaceType: template.surfaceType,
                  totalFinancialCommitment: template.totalFinancialCommitment,
                  points: template.points,
                  draw: template.draw,
                  startDate: startDate)
    }
}

