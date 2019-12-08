//
//  String+Convenience.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        guard !self.isEmpty else { return true }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
