//
//  ScreenViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import Swinject

class ScreenViewController: UIViewController {
    // MARK: - Properties
    
    let resolver = DIContainer.defaultResolver
    private(set) var dataManager: DataManager!
    private(set) var appState: AppState!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
    }
    
    
    
    // MARK: - Public
    
    func setupDependencies() {
        dataManager = resolver.resolve(DataManager.self)
        appState = resolver.resolve(AppState.self)
    }
    
    @discardableResult func presentViewController(withIdentifier identifier: String, storyboardIdentifier: String? = nil, fromNavigation: Bool = false) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier ?? identifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        guard fromNavigation else {
            controller.modalPresentationStyle = .fullScreen
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
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    
    // MARK: - Private
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
