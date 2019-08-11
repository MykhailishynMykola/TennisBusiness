//
//  CountriesDataManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class CountriesDataManager {
    static let shared = CountriesDataManager()
    
    var countries: [Country] = []
    
    private init() {
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let jsonResult = try? JSONSerialization.jsonObject(with: data),
            let arrayData = jsonResult as? [[String: String]] else {
            return
        }
        let countries: [Country] = arrayData.compactMap { dict in
            guard let name = dict["name"], let code = dict["code"] else {
                print("Error: Can't parse country with name \(dict["name"] ?? "")")
                return nil
            }
            return Country(name: name, code: code.lowercased())
        }
        self.countries = countries
    }
}
