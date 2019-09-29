//
//  NamesDataManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 9/29/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

protocol NamesDataManager {
    var names: [String] { get }
    var surnames: [String] { get }
    
    func getRandomName() -> (name: String?, surname: String?)
}


final class NamesDataManagerImp: NamesDataManager {
    // MARK: - Properties
    
    let names: [String]
    let surnames: [String]
    
    
    
    // MARK: - Init
    
    init() {
        guard let namesUrl = Bundle.main.url(forResource: "First_names", withExtension: "json"),
            let surnamesUrl = Bundle.main.url(forResource: "Last_names", withExtension: "json"),
            let namesData = try? Data(contentsOf: namesUrl),
            let surnamesData = try? Data(contentsOf: surnamesUrl),
            let namesJson = try? JSONSerialization.jsonObject(with: namesData),
            let surnamesJson = try? JSONSerialization.jsonObject(with: surnamesData),
            let namesArray = namesJson as? [String],
            let surnamesArray = surnamesJson as? [String] else {
                self.names = []
                self.surnames = []
                return
        }
        self.names = namesArray
        self.surnames = surnamesArray
    }
    
    
    
    // MARK: - Public
    
    func getRandomName() -> (name: String?, surname: String?) {
        return (name: names.randomElement(), surname: surnames.randomElement())
    }
}
