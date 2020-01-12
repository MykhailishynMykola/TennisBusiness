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
        emailTextField.placeholder = localized("KEY_EMAIL")
        passwordTextField.placeholder = localized("KEY_PASSWORD")
        confirmPasswordTextField.placeholder = localized("KEY_CONFIRM_PASSWORD")
        registrationButton.configureButton(backgroundColor: .primary, titleColor: .title, title: localized("KEY_SIGNUP"), cornerRadius: 20)
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
        let alertController = UIAlertController(title: localized("KEY_ERROR_TITLE"), message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: localized("KEY_OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func registrationButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailTextField.text, mail.isValidEmail(), !mail.isEmpty  else {
            showErrorMessage(error: localized("KEY_ERROR_WRONG_EMAIL"))
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showErrorMessage(error: localized("KEY_ERROR_WRONG_PASSWORD"))
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
            password == confirmPassword else {
            showErrorMessage(error: localized("KEY_ERROR_WRONG_CONFIRMATION_PASSWORD"))
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
