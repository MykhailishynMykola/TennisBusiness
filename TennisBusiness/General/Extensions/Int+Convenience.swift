//
//  Int+Convenience.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

extension Int {
    static func random(from fromNubmer: Int, to toNumber: Int) -> Int {
        var offset = 0
        
        if fromNubmer < 0 {
            offset = abs(fromNubmer)
        }
        
        let mini = UInt32(fromNubmer + offset)
        let maxi = UInt32(toNumber + 1 + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
