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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .primaryColor
        navigationBar.layer.shadowRadius = 3
        navigationBar.layer.shadowColor = UIColor.darkGray.cgColor
        navigationBar.layer.shadowOpacity = 0.3
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(r: 10, g: 10, b: 10)]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(r: 10, g: 10, b: 10)]
        
        navigationBar.prefersLargeTitles = true
    }

}
