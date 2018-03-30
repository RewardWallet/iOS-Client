//
//  SignUpViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class SignUpViewController: LoginViewController {
    
    var confirmPasswordTextField: UITextField = {
        let textField = UIAnimatedTextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tintColor = .secondaryColor
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        loginButton.setTitle("Sign Up", for: .normal)
        passwordViewToggleButton.isHidden = true
        passwordResetButton.isHidden = true
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.anchor(passwordTextField.bottomAnchor, left: emailTextField.leftAnchor, right: emailTextField.rightAnchor, topConstant: 30, heightConstant: 44)
    }
    
    // MARK: - Additional Validation
    
    override func handleLogin() {
        guard passwordTextField.text == confirmPasswordTextField.text else {
            handleError(.passwordMismatch)
            return
        }
        super.handleLogin()
    }
    
    // MARK: - User Actions
    
    override func authorize(_ email: String, password: String) {
        
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        User.signUpInBackground(email: email, password: password) { (success, error) in
            API.shared.dismissProgressHUD()
            guard success else {
                self.presentError(error?.localizedDescription)
                return
            }
            AppRouter.shared.present(.explore, wrap: nil,
                                     from: nil, animated: true, completion: nil)
        }

    }
    
}
