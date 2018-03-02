//
//  PrimaryNavigationController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class PrimaryNavigationController: RWNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .primaryColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.prefersLargeTitles = true
    }
    
}
