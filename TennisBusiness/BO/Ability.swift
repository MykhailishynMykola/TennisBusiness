//
//  Ability.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Ability {
    var skill: AbilityValue
    
    init(skill: AbilityValue) {
        self.skill = skill
    }
}

class AbilityValue {
    private let value: Double
    
    var doubleValue: Double {
        return value
    }
    
    var intValue: Int {
        return Int(value)
    }
    
    init(value: Double) {
        self.value = max(min(value, 10), 0)
    }
}
