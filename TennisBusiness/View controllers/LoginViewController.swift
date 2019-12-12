//
//  LoginViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/15/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class LoginViewController: ScreenViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    private var authDataManager: AuthDataManager!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.setupDependencies()
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        loginButton.setRoundedButtonWithColor(background: .appColor, title: .title)
        registrationButton.setRoundedButtonWithColor(background: .callToAction, title: .title)
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
    
    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailTextField.text, mail.isValidEmail() else {
           showErrorMessage(error: "Enter valid email")
           return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
           showErrorMessage(error: "Enter password")
           return
        }
        authDataManager.signInFB(with: mail, password: password)
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
    
    @IBAction private func registrationButtonTouchUpInside(_ sender: Any) {
        presentViewController(withIdentifier: "Registration", fromNavigation: false)
    }
}
