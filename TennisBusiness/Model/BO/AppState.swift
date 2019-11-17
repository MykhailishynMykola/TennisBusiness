//
//  AppState.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/15/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

final class AppState {
    private(set) var currentUser: User?
    
    func updateCurrentUser(_ user: User) {
        currentUser = user
    }
}
