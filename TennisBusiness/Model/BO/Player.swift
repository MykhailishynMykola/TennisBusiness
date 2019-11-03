//
//  Player.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//
import Foundation

class Player {
    // MARK: - Inner
    
    static var empty = Player(identifier: "", name: "", surname: "", ability: .empty, country: nil, birthday: Date())
    
    
    
    // MARK: - Properties
    
    let identifier: String
    let name: String
    let surname: String
    var ability: Ability
    let country: Country?
    let birthday: Date
    
    
    
    // MARK: - init
    
    init(identifier: String, name: String, surname: String, ability: Ability, country: Country?, birthday: Date) {
        self.identifier = identifier
        self.name = name
        self.surname = surname
        self.ability = ability
        self.country = country
        self.birthday = birthday
    }
    
    var fullName: String {
        return "\(name) \(surname)"
    }
}
