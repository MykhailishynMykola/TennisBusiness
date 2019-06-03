//
//  Snapshot+JSON.swift
//  TennisBusiness
//
//  Created by user on 6/3/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension Player {
    convenience init?(snapshot: QueryDocumentSnapshot) {
        let playerData = snapshot.data()
        guard let identifier = playerData["identifier"] as? String,
            let name = playerData["name"] as? String,
            let abilityDict = playerData["ability"] as? [String: Double],
            let skillValue = abilityDict["skill"],
            let serveValue = abilityDict["serve"],
            let returnValue = abilityDict["return"] else {
                return nil
        }
        let ability = Ability(skill: AbilityValue(value: skillValue),
                              serve: AbilityValue(value: serveValue),
                              returnOfServe: AbilityValue(value: returnValue))
        self.init(identifier: identifier, name: name, ability: ability)
    }
}
