//
//  LoginViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class LoginViewController: UILoginViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tintColor = .primaryColor
        loginButton.backgroundColor = .secondaryColor
        emailTextField.tintColor = .secondaryColor
        passwordTextField.tintColor = .secondaryColor
        passwordResetButton.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        #if DEBUG
            emailTextField.text = "ntannar@sfu.ca"
            passwordTextField.text = "oR3Jp5YMyxS"
        #endif
    }
    
    // MARK: - Error Handling
    
    override func presentError(_ text: String? = "Sorry, an unexpected error occurred") {
        // TODO: Change to a notification of some kind
        print(text ?? "Error")
    }
    
    // MARK: - User Actions
    
    @objc
    func didTapCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func authorize(_ email: String, password: String) {
        
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        User.loginInBackground(email: email, password: password) { (success, error) in
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
