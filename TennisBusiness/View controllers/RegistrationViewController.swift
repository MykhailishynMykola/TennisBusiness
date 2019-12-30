//
//  RegistrationViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class RegistrationViewController: ScreenViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var registrationButton: UIButton!
    
    private var authDataManager: AuthDataManager!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.configureButton(background: .appColor, title: .title, cornerRadius: 20)
    }

    override func setupDependencies() {
        super.setupDependencies()
        authDataManager = resolver.resolve(AuthDataManager.self)
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        if textField == confirmPasswordTextField {
            view.endEditing(true)
        }
        return true
    }
    
    
    
    // MARK: - Private
    
    private func showErrorMessage(error: String) {
        let alertController = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func registrationButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailTextField.text, mail.isValidEmail() else {
            showErrorMessage(error: "Enter valid email")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showErrorMessage(error: "Enter password")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
            password == confirmPassword else {
            showErrorMessage(error: "Your password and confirmation password do not match")
            return
        }
        
        authDataManager.createUser(with: mail, password: password)
            .then { [weak self] user -> Void in
                self?.appState.updateCurrentUser(user)
                if user.admin {
                    self?.presentViewController(withIdentifier: "ModeratorMain", fromNavigation: true)
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                else {
                    self?.presentViewController(withIdentifier: "UserMain")
                }
            }
            .catch { [weak self] error in
                self?.showErrorMessage(error: error.localizedDescription)
        }
    }
    
    @IBAction private func closeButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
