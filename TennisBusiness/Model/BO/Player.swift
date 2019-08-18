//
//  Player.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Player {
    let identifier: String
    let name: String
    var ability: Ability
    
    init(identifier: String, name: String, ability: Ability) {
        self.identifier = identifier
        self.name = name
        self.ability = ability
    }
}
