//
//  RWNavigationController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

/// A RewardWallet base class for UINavigationController
class RWNavigationController: UINavigationController {
    
    var statusBar: UIView? {
        return UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navigationBar.isHidden {
            return viewControllers.first?.preferredStatusBarStyle ?? .default
        }
        return (navigationBar.barTintColor?.isDark ?? false) ? .lightContent : .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
