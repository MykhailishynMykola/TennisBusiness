//
//  ScreenViewController.swift
//  TennisBusiness
//
//  Created by user on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import Swinject

class ScreenViewController: UIViewController {
    // MARK: - Properties
    
    let resolver = DIContainer.defaultResolver
    var dataManager: DataManager!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
    }
    
    
    
    // MARK: - Public
    
    func setupDependencies() {
        dataManager = resolver.resolve(DataManager.self)
    }
    
    @discardableResult func presentViewController(withIdentifier identifier: String, storyboardIdentifier: String? = nil, fromNavigation: Bool = false) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier ?? identifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        guard fromNavigation else {
            present(controller, animated: true, completion: nil)
            return controller
        }
        if let navigationController = navigationController {
            navigationController.pushViewController(controller, animated: true)
        }
        else {
            let navigationController = UINavigationController(rootViewController: controller)
            present(navigationController, animated: true)
        }
        return controller
    }
}
