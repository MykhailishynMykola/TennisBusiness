//
//  Tournament+Snapshot.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 11/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Tournament {
    convenience init?(snapshot: QueryDocumentSnapshot, countries: [Country]) {
        let tournamentData = snapshot.data()
        guard let name = tournamentData["name"] as? String,
            let city = tournamentData["city"] as? String,
            let week = tournamentData["week"] as? Int,
            let surfaceRaw = tournamentData["surface"] as? String,
            let surface = Surface(rawValue: surfaceRaw),
            let surfaceTypeRaw = tournamentData["surfaceType"] as? String,
            let surfaceType = SurfaceLocationType(rawValue: surfaceTypeRaw),
            let totalFinancialCommitment = tournamentData["totalFinancialCommitment"] as? Double,
            let pointsRaw = tournamentData["points"] as? String,
            let points = TournamentPoints(rawValue: pointsRaw),
            let drawSingle = tournamentData["drawSingle"] as? Int,
            let drawDouble = tournamentData["drawDouble"] as? Int,
            let startDate = tournamentData["startDate"] as? Timestamp else {
                return nil
        }
        let countryCode = tournamentData["countryCode"] as? String
        let country = countries.first(where: {$0.code == countryCode})
        self.init(identifier: snapshot.documentID,
                  name: name,
                  city: city,
                  country: country,
                  week: week,
                  surface: surface,
                  surfaceType: surfaceType,
                  totalFinancialCommitment: totalFinancialCommitment,
                  points: points,
                  draw: (single: drawSingle, double: drawDouble),
                  startDate: startDate.dateValue())
    }
}

