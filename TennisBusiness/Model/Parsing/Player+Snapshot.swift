//
//  Player+Snapshot.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/3/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Player {
    convenience init?(snapshot: QueryDocumentSnapshot) {
        let playerData = snapshot.data()
        guard let name = playerData["name"] as? String,
            let abilityDict = playerData["ability"] as? [String: Double],
            let skillValue = abilityDict["skill"],
            let serveValue = abilityDict["serve"],
            let returnValue = abilityDict["return"] else {
                return nil
        }
        let ability = Ability(skill: skillValue,
                              serve: serveValue,
                              returnOfServe: returnValue)
        self.init(identifier: snapshot.documentID, name: name, ability: ability)
    }
}
