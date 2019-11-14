//
//  RegistrationViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    // MARK: - Actions
    
    @IBAction func registrationButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailTextField.text, !mail.isValidEmail() else {
            showErrorMessage(error: "Enter valid email")
            return
        }
        guard let password = passwordTextField.text else {
            showErrorMessage(error: "Enter password")
            return
        }
        
        
    }
    
    
    
    // MARK: - Private
    
    func showErrorMessage(error: String) {
        let alertController = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
