//
//  HistoryTabBarController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-13.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import DynamicTabBarController

class HistoryTabBarController: DynamicTabBarController {
    
    // MARK: - Initialization
    
    required init(viewControllers: [UIViewController]) {
        super.init(viewControllers: viewControllers)
        title = "History"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_bell?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_bell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        tabBar.backgroundColor = .primaryColor
        tabBar.activeTintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarPosition = .top
        tabBar.scrollIndicatorPosition = .bottom
        updateTabBarHeight(to: 30, animated: animated)
    }
    
}
