//
//  ResetPasswordViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 1/19/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ResetPasswordViewController: ScreenViewController, UITextFieldDelegate {
    // MARK: - Inner
    
    private struct Constants {
        static let scrollInset: CGFloat = 5
    }
    
    
    
    // MARK: - Properties
    
    @IBOutlet private weak var emailView: TextField!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var authDataManager: AuthDataManager!
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        resetPasswordButton.configureButton(backgroundColor: .primary, titleColor: .title, title: localized("KEY_RESET_PASSWORD"), cornerRadius: 20)
        descriptionLabel.text = localized("KEY_RESET_PASSWORD_DESCRIPTION")
        emailView.textField.placeholder = localized("KEY_EMAIL")
        emailView.textField.keyboardType = .emailAddress
        emailView.textField.returnKeyType = .done
        emailView.textField.autocorrectionType = .no
        emailView.textField.autocapitalizationType = .none
        emailView.textField.delegate = self
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
            view.endEditing(true)
            resetPasswordTouchUpInside(textField)
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
       scrollView.contentInset = .zero
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func resetPasswordTouchUpInside(_ sender: Any) {
        guard let mail = emailView.textField.text, mail.isValidEmail(), !mail.isEmpty else {
           showErrorMessageKey("KEY_ERROR_WRONG_EMAIL")
           return
        }
        authDataManager.resetPassword(with: mail)
            .then { [weak self] () -> Void in
                self?.dismiss(animated: true, completion: nil)
            }
            .catch { [weak self] error in
                self?.showErrorMessage(error.localizedDescription)
        }
    }
    
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
