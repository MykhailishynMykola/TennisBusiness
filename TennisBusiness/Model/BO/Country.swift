//
//  Country.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

class Country: Equatable {
    // MARK: - Properties
    
    let name: String
    let code: String
    
    
    
    // MARK: - Init
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}



extension Array where Element: Country {
    func findCountry(withName name: String) -> Country? {
        return self.first(where: { $0.name.lowercased() == name.lowercased() })
    }
    
    func findCountry(withCode code: String) -> Country? {
        return self.first(where: { $0.code.lowercased() == code.lowercased() })
    }
}



// MARK: - Equatable
func == (lhs: Country, rhs: Country) -> Bool {
    return lhs.code == rhs.code
        && lhs.name == rhs.name
}
