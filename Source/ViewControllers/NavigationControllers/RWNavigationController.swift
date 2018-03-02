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
        return (navigationBar.barTintColor?.isDark ?? false) ? .lightContent : .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layer.shadowRadius = 3
        navigationBar.layer.shadowColor = UIColor.darkGray.cgColor
        navigationBar.layer.shadowOpacity = 0.3
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }

}
