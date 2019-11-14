//
//  User.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/14/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class User {
    // MARK: - Properties
    
    let identifier: String
    let email: String
    let admin: Bool
    
    
    
    // MARK: - init
    
    init(identifier: String, email: String, admin: Bool) {
        self.identifier = identifier
        self.email = email
        self.admin = admin
    }
}
