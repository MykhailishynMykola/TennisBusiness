//
//  ResolverInitializable.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/17/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Swinject

/// Object, which can be initialized, getting its dependencies from given resolver.
protocol ResolverInitializable {
    /// Creates a new instance of given object with given resolver used to inject dependencies.
    /// - Note: If object cannot retrieve necessary dependencies, initializer fails.
    ///
    /// - Parameter resolver: Dependencies container.
    /// - Returns: New instance with all dependencies.
    init?(resolver: Resolver)
}
