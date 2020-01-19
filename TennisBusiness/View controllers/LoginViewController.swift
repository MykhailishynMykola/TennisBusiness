//
//  LoginViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 11/15/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class LoginViewController: ScreenViewController, UITextFieldDelegate {
    // MARK: - Inner
    
    private struct Constants {
        static let scrollInset: CGFloat = 5
    }
    
    
    
    // MARK: - Properties
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var emailView: TextField!
    @IBOutlet private weak var passwordView: TextField!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var authDataManager: AuthDataManager!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        loginButton.configureButton(backgroundColor: .primary, titleColor: .title, title: localized("KEY_LOGIN"), cornerRadius: 20)
        registrationButton.configureButton(backgroundColor: .secondary, titleColor: .title, title: localized("KEY_SIGNUP"), cornerRadius: 20)
        emailView.textField.placeholder = localized("KEY_EMAIL")
        emailView.textField.keyboardType = .emailAddress
        emailView.textField.returnKeyType = .next
        emailView.textField.autocorrectionType = .no
        emailView.textField.autocapitalizationType = .none
        emailView.textField.delegate = self
        
        passwordView.textField.placeholder = localized("KEY_PASSWORD")
        passwordView.textField.returnKeyType = .done
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.textContentType = .password
        passwordView.textField.delegate = self
        
        forgotPasswordButton.setTitle(localized("KEY_FORGOT_PASSWORD"), for: .normal)
        forgotPasswordButton.setTitleColor(.secondary, for: .normal)
    }
    
    override func setupDependencies() {
        super.setupDependencies()
        authDataManager = resolver.resolve(AuthDataManager.self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + Constants.scrollInset + TextField.Constants.bottomLineInset
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        let contentInset: UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        guard let mail = emailView.textField.text, mail.isValidEmail(), !mail.isEmpty else {
           showErrorMessageKey("KEY_ERROR_WRONG_EMAIL")
           return
        }
        guard let password = passwordView.textField.text, !password.isEmpty else {
           showErrorMessageKey("KEY_ERROR_WRONG_PASSWORD")
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
                self?.showErrorMessage(error.localizedDescription)
        }
    }
    
    @IBAction private func registrationButtonTouchUpInside(_ sender: Any) {
        presentViewController(withIdentifier: "Registration", fromNavigation: false)
    }
    
    @IBAction private func forgotPasswordTouchUpInside(_ sender: Any) {
        presentViewController(withIdentifier: "ResetPassword", fromNavigation: false)
    }
    
}
