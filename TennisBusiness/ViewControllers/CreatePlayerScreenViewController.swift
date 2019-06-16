//
//  CreatePlayerScreenViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/16/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class CreatePlayerScreenViewController: ScreenViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var skillField: UITextField!
    @IBOutlet private weak var serveField: UITextField!
    @IBOutlet private weak var returnField: UITextField!
    
    private var world: World?
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        self.world = world
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func createPlayerPressed(_ sender: Any) {
        guard let name = nameField.text,
            let skill = Double(skillField.text ?? ""),
            let serve = Double(serveField.text ?? ""),
            let returnOfServe = Double(returnField.text ?? ""),
            let worldIdentifier = world?.identifier else {
                return
        }
        let ability = Ability(skill: skill,
                              serve: serve,
                              returnOfServe: returnOfServe)
        dataManager.createPlayer(with: name, ability: ability, worldIdentifier: worldIdentifier)
            .then { [weak self] player -> Void in
                self?.world?.players.append(player)
                self?.dismiss(animated: true, completion: nil)
        }
    }
}
