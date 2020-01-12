//
//  User.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/14/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class User {
    // MARK: - Inner types
    
    struct RelatedPlayerInfo {
        let worldIdentifier: String
        let playerIdentifier: String
    }
    
    
    
    // MARK: - Properties
    
    let identifier: String
    let email: String
    let admin: Bool
    let relatedPlayerInfos: [RelatedPlayerInfo]
    
    
    
    // MARK: - init
    
    init(identifier: String, email: String, admin: Bool, relatedPlayerInfos: [RelatedPlayerInfo]) {
        self.identifier = identifier
        self.email = email
        self.admin = admin
        self.relatedPlayerInfos = relatedPlayerInfos
    }
}
