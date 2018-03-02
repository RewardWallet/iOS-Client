//
//  AccountViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class AccountViewController: RWViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_user?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_user)
        
    }
}
