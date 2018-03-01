//
//  LoginViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class LoginViewController: UILoginViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tintColor = .primaryColor
        emailTextField.tintColor = .secondaryColor
        passwordTextField.tintColor = .secondaryColor
        passwordResetButton.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    }
    
    // MARK: - User Actions
    
    @objc
    func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
}
