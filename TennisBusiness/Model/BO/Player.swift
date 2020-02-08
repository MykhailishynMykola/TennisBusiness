//
//  Player.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Player: Codable {
    // MARK: - Inner
    
    static var empty = Player(documentID: "", name: "", surname: "", ability: .empty, countryCode: "", birthday: nil)
    
    
    
    // MARK: - Properties
    
    let documentID: String
    let name: String
    let surname: String
    var ability: Ability
    let countryCode: String
    var country: Country?
    let birthday: Timestamp?
    
    var birthdayDate: Date? {
        return birthday?.dateValue()
    }
    
    
    
    // MARK: - Init
    
    init(documentID: String, name: String, surname: String, ability: Ability, countryCode: String, birthday: Timestamp?) {
        self.documentID = documentID
        self.name = name
        self.surname = surname
        self.ability = ability
        self.countryCode = countryCode
        self.birthday = birthday
    }
    
    var fullName: String {
        return "\(name) \(surname)"
    }
}
