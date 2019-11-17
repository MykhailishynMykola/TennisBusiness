//
//  User+Snapshot.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/15/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension User {
    convenience init?(snapshot: DocumentSnapshot) {
        guard let userData = snapshot.data(),
            let email = userData["email"] as? String,
            let admin = userData["admin"] as? Bool else {
                return nil
        }
        self.init(identifier: snapshot.documentID, email: email, admin: admin)
    }
}
