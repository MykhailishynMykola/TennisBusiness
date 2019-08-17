//
//  ManagersAssembly.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 8/17/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Swinject

final class ManagersAssembly: Assembly {
    // MARK: - Assembly
    
    func assemble(container: Container) {
        container.register(CalculationManager.self) { CalculationManagerImp(resolver: $0)! }
            .inObjectScope(.container)
        container.register(DataManager.self) { _ in DataManagerImp() }
        container.register(CountriesDataManager.self) { _ in CountriesDataManagerImp() }
            .inObjectScope(.container)
    }
}
