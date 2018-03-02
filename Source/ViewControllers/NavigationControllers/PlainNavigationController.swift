//
//  PlainNavigationController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class PlainNavigationController: RWNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .secondaryColor
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
    }
    
}
