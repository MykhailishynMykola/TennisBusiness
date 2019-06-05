//
//  Match+Snapshot.swift
//  TennisBusiness
//
//  Created by user on 6/5/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Match {
    convenience init?(snapshot: QueryDocumentSnapshot, world: World) {
        let matchData = snapshot.data()
        guard let matchIdentifier = matchData["identifier"] as? String,
            let setsToWin = matchData["setsToWin"] as? Int,
            let player1Identifier = matchData["player1"] as? String,
            let player2Identifier = matchData["player2"] as? String,
            let player1 = world.players[player1Identifier],
            let player2 = world.players[player2Identifier] else {
                return nil
        }
        self.init(identifier: matchIdentifier, firstPlayer: player1, secondPlayer: player2, setsToWin: setsToWin)
    }
}
