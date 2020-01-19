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
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var emailView: TextField!
    @IBOutlet private weak var passwordView: TextField!
    
    private var authDataManager: AuthDataManager!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        loginButton.configureButton(backgroundColor: .primary, titleColor: .title, title: localized("KEY_LOGIN"), cornerRadius: 20)
        registrationButton.configureButton(backgroundColor: .secondary, titleColor: .title, title: localized("KEY_SIGNUP"), cornerRadius: 20)
        emailView.textField.placeholder = localized("KEY_EMAIL")
        emailView.textField.keyboardType = .emailAddress
        emailView.textField.returnKeyType = .next
        emailView.textField.autocorrectionType = .no
        emailView.textField.delegate = self
        
        passwordView.textField.placeholder = localized("KEY_PASSWORD")
        passwordView.textField.returnKeyType = .done
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.textContentType = .newPassword
        passwordView.textField.delegate = self
    }
    
    override func setupDependencies() {
        super.setupDependencies()
        authDataManager = resolver.resolve(AuthDataManager.self)
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailView.textField {
            passwordView.textField.becomeFirstResponder()
        }
        
        if textField == passwordView.textField {
            view.endEditing(true)
            loginButtonTouchUpInside(textField)
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
    
    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailView.textField.text, mail.isValidEmail(), !mail.isEmpty else {
           showErrorMessage(error: localized("KEY_ERROR_WRONG_EMAIL"))
           return
        }
        guard let password = passwordView.textField.text, !password.isEmpty else {
           showErrorMessage(error: localized("KEY_ERROR_WRONG_PASSWORD"))
           return
        }
        
        authDataManager.signInFB(with: mail, password: password)
            .then { [weak self] user -> Void in
                self?.appState.updateCurrentUser(user)
                guard !user.admin else {
                    self?.presentViewController(withIdentifier: "ModeratorMain", fromNavigation: true)
                    UIApplication.shared.isIdleTimerDisabled = true
                    return
                }
                if user.relatedPlayerInfos.isEmpty {
                    self?.presentViewController(withIdentifier: "ChooseWorld")
                    return
                }
                self?.presentViewController(withIdentifier: "UserMain")
            }
            .catch { [weak self] error in
                self?.showErrorMessage(error: error.localizedDescription)
        }
    }
    
    @IBAction private func registrationButtonTouchUpInside(_ sender: Any) {
        presentViewController(withIdentifier: "Registration", fromNavigation: false)
    }
}
