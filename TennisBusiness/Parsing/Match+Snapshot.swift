//
//  Match+Snapshot.swift
//  TennisBusiness
//
//  Created by user on 6/5/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Match {
    convenience init?(snapshot: QueryDocumentSnapshot, players: [Player]) {
        let matchData = snapshot.data()
        guard let setsToWin = matchData["setsToWin"] as? Int,
            let eventDate = matchData["eventDate"] as? Timestamp,
            let result = matchData["result"] as? String,
            let player1Identifier = matchData["player1"] as? String,
            let player2Identifier = matchData["player2"] as? String,
            let player1 = players.first(where: { $0.identifier == player1Identifier }),
            let player2 = players.first(where: { $0.identifier == player2Identifier }) else {
                return nil
        }
        self.init(identifier: snapshot.documentID, firstPlayer: player1, secondPlayer: player2, setsToWin: setsToWin, eventDate: eventDate.dateValue(), result: result)
    }
}
