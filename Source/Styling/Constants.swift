//
//  AppRouter.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/5/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var primaryColor: UIColor {
        return .white
    }
    
    static var secondaryColor: UIColor {
        return UIColor(r: 39, g: 111, b: 251)
    }
    
    static var tertiaryColor: UIColor {
        return UIColor(r: 159, g: 65, b: 251)
    }
    
    static var backgroundColor: UIColor {
        return UIColor(r: 250, g: 250, b: 250)
    }
    
}

extension UIImage {
    
    static var icon_wallet: UIImage? {
        return UIImage(named: "Bank Card Back Side")
    }
    
    static var icon_bell: UIImage? {
        return UIImage(named: "Appointment Reminders")
    }
    
    static var icon_rw_coin: UIImage? {
        return UIImage(named: "Coin")
    }
    
}

