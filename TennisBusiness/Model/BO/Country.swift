//
//  Country.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

struct Country: Equatable {
    let name: String
    let code: String
}



// MARK: - Equatable
func == (lhs: Country, rhs: Country) -> Bool {
    return lhs.code == rhs.code
        && lhs.name == rhs.name
}
