//
//  ExploreViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class ExploreViewController: RWViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_shop?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_shop)
        
    }
}
