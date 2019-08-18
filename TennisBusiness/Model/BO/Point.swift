//
//  Point.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

enum Point: String {
    case zero = "0"
    case fifteen = "15"
    case thirty = "30"
    case fourty = "40"
    case advantage = "A"
    case disadvantage = "-"
    
    static var numerable: [Point] { return [.zero, .fifteen, .thirty, .fourty] }
    
    static func next(after: Point) -> Point? {
        guard let currentIndex = numerable.index(of: after),
            currentIndex != numerable.indices.last else {
            return nil
        }
        let nextIndex = numerable.index(after: currentIndex)
        return numerable[nextIndex]
    }
}
