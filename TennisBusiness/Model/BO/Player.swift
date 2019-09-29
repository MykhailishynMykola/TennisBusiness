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
    let surname: String
    var ability: Ability
    let country: Country?
    
    init(identifier: String, name: String, surname: String, ability: Ability, country: Country?) {
        self.identifier = identifier
        self.name = name
        self.surname = surname
        self.ability = ability
        self.country = country
    }
    
    var fullName: String {
        return name + " " + surname
    }
}
