//
//  User+Snapshot.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/15/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension User {
    convenience init?(snapshot: DocumentSnapshot, infosSnapshot: [QueryDocumentSnapshot]) {
        guard let userData = snapshot.data(),
            let email = userData["email"] as? String,
            let admin = userData["admin"] as? Bool else {
                return nil
        }
        
        let infos = infosSnapshot.compactMap { snap -> User.RelatedPlayerInfo? in
            guard snap.exists else { return nil }
            let data = snap.data()
            let worldIdentifier: String = snap.documentID
            guard let playerIdentifier = data["player"] as? String else {
                return nil
            }
            return User.RelatedPlayerInfo(worldIdentifier: worldIdentifier,
                                          playerIdentifier: playerIdentifier)
        }
        self.init(identifier: snapshot.documentID, email: email, admin: admin, relatedPlayerInfos: infos)
    }
}
