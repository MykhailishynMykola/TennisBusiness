//
//  DIContainer.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/17/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Swinject

/// Provides a namespace for default DI resolver. Instances of this class are useless.
final class DIContainer {
    /// Default DI resolver, used in the app.
    static private(set) var defaultResolver: Resolver = {
        let assemblies: [Assembly] = [ManagersAssembly()]
        let assembler = Assembler(assemblies)
        let resolver = (assembler.resolver as? Container)?.synchronize() ?? assembler.resolver
        return resolver
    }()
}
