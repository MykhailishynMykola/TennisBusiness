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
    
    func ageInt(to: Date) -> Int {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year], from: self, to: to)
        guard let countYear = dateComponent.year else { return 0 }
        return countYear
    }
}
