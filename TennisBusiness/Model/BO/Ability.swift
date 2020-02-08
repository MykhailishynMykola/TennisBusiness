//
//  Ability.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Ability: Codable {
    // MARK: - Inner
    
    static var empty = Ability(skill: 0, serve: 0, returnOfServe: 0, countryBonus: 0)
    
    
    
    // MARK: - Properties
    
    var skill: AbilityValue
    var serve: AbilityValue
    var returnOfServe: AbilityValue
    var countryBonus: AbilityValue
    
    
    
    // MARK: - Init
    
    init(skill: Double, serve: Double, returnOfServe: Double, countryBonus: Double) {
        self.skill = AbilityValue(value: skill)
        self.serve = AbilityValue(value: serve)
        self.returnOfServe = AbilityValue(value: returnOfServe)
        self.countryBonus = AbilityValue(value: countryBonus)
    }
    
    private init(skill: AbilityValue, serve: AbilityValue, returnOfServe: AbilityValue, countryBonus: AbilityValue) {
        self.skill = skill
        self.serve = serve
        self.returnOfServe = returnOfServe
        self.countryBonus = countryBonus
    }
    
    
    
    // MARK: - Protocols
    // MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
        case skill, serve, returnOfServe, countryBonus
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(skill.doubleValue, forKey: .skill)
        try container.encode(serve.doubleValue, forKey: .serve)
        try container.encode(returnOfServe.doubleValue, forKey: .returnOfServe)
        try container.encode(countryBonus.doubleValue, forKey: .countryBonus)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let skillValue = try container.decode(Double.self, forKey: .skill)
        let serveValue = try container.decode(Double.self, forKey: .serve)
        let returnOfServeValue = try container.decode(Double.self, forKey: .returnOfServe)
        let countryBonusValue = try container.decode(Double.self, forKey: .countryBonus)
        self.init(skill: skillValue, serve: serveValue, returnOfServe: returnOfServeValue, countryBonus: countryBonusValue)
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
