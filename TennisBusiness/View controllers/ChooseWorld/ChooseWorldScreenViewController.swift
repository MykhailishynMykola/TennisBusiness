//
//  ChooseWorldScreenViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ChooseWorldScreenViewController: ScreenViewController, ChooseWorldLayoutControllerDelegate {
    // MARK: - Inner types
    
    private enum SegueIdentifier: String {
        case showLayout = "showLayout"
    }
    
    
    
    // MARK: - Properties
    
    private var layoutController: ChooseWorldLayoutController?
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getWorlds()
            .then { [weak self] worlds in
                self?.layoutController?.worlds = worlds
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case SegueIdentifier.showLayout.rawValue:
            var layoutController = segue.destination as? ChooseWorldLayoutController
            layoutController?.delegate = self
            
            self.layoutController = layoutController
        default:
            break
        }
    }
}
