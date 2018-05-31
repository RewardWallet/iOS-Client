//
//  DispatchViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class DispatchViewController: RWViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Subviews
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        view.addSubview(activityIndicator)
        activityIndicator.anchorCenterToSuperview()
        activityIndicator.anchor(widthConstant: 100, heightConstant: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator.startAnimating()
        LocationManager.shared.beginTracking()
        
        // TODO: - Load any content required, restore user session
        AppRouter.shared.present(.explore, wrap: nil, from: nil, animated: false, completion: nil)
    }
}
