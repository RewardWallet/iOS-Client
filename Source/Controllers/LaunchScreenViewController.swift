//
//  LaunchScreenViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/10/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import URLNavigator

class LaunchScreenViewController: RWViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = AppRoute.wallet.pattern.urlValue else { return }
        AppRouter.shared.present(url, context: nil, wrap: RWNavigationController.self, from: nil, animated: true, completion: nil)
    }
}
