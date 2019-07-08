//
//  Date+Convenience.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 7/6/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

extension Date {
    func stringWithSeconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
