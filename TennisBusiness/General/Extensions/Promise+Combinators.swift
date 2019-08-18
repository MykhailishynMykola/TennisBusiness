//
//  Promise+Combinators.swift
//  3Ready
//
//  Created by Nikolay Mikhailishin on 8/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import PromiseKit

/// Waits for all promises being resolved and returns results of only those, which were fulfilled.
func collectSuccesses<U>(_ promises: [Promise<U>]) -> Promise<[U]> {
    // Transform promises to return optional results
    return when(resolved: promises).then { results in
        results.compactMap {
            switch $0 {
            case .fulfilled(let value):
                return value
            default:
                return nil
            }
        } // Unwraps optional results and filters out nils
    }
}
