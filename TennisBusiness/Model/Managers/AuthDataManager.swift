//
//  AuthDataManager.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/14/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

protocol AuthDataManager {
    func createUser(with mail: String, password: String) -> Promise<User>
}

final class AuthDataManagerImp: AuthDataManager {
    func createUser(with mail: String, password: String) -> Promise<User> {
        return Promise(resolvers: { (fulfill, reject) in
            Auth.auth().createUser(withEmail: mail, password: password) { (result, error) in
                if let error = error {
                    reject(error)
                }
                guard let authUser = result?.user else { return reject(NSError.cancelledError())}
                let user = User(identifier: authUser.uid, email: mail, admin: false)
                fulfill(user)
            }
        })
        .then { user -> Promise<User> in
            return self.createFBUser(user: user).then { () -> Promise<User> in
                     return Promise(value: user)
            }
        }
    }
    
    func createFBUser(user: User) -> Promise<Void> {
        return Promise<Void>(resolvers: { (fulfill, reject) in
            let newUser: [String: Any] = ["email": user.email,
                                          "admin": false]
            var newUserReference: DocumentReference? = nil
            newUserReference = database.collection("users")
                .document(user.identifier)
                .setData(data: newUser) { error in
                    guard error == nil,
                        let newUserIdentifier = newUserReference?.documentID else {
                            print("Error: Failed to create a new user.")
                            if let error = error { reject(error) }
                            return
                    }
                    fulfill(())
            }
        })
    }

}
