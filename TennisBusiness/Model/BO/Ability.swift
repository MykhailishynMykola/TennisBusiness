//
//  Ability.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Ability {
    var skill: AbilityValue
    var serve: AbilityValue
    var returnOfServe: AbilityValue
    
    init(skill: Double, serve: Double, returnOfServe: Double) {
        self.skill = AbilityValue(value: skill)
        self.serve = AbilityValue(value: serve)
        self.returnOfServe = AbilityValue(value: returnOfServe)
    }
    
    private init(skill: AbilityValue, serve: AbilityValue, returnOfServe: AbilityValue) {
        self.skill = skill
        self.serve = serve
        self.returnOfServe = returnOfServe
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