//
//  Match+Snapshot.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/5/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Match {
    convenience init?(snapshot: QueryDocumentSnapshot, players: [Player], countries: [Country]) {
        let matchData = snapshot.data()
        guard let setsToWin = matchData["setsToWin"] as? Int,
            let eventDate = matchData["eventDate"] as? Timestamp,
            let player1Identifier = matchData["player1"] as? String,
            let player2Identifier = matchData["player2"] as? String,
            let player1 = players.first(where: { $0.documentID == player1Identifier }),
            let player2 = players.first(where: { $0.documentID == player2Identifier }) else {
                return nil
        }
        let countryCode = matchData["countryCode"] as? String
        let country = countries.first(where: {$0.code == countryCode})
        let result = matchData["result"] as? String ?? ""
        self.init(identifier: snapshot.documentID, firstPlayer: player1, secondPlayer: player2, setsToWin: setsToWin, eventDate: eventDate.dateValue(), result: result, country: country)
    }
}
