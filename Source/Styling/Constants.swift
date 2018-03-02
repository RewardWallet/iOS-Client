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
        return UIColor(r: 39, g: 111, b: 251)
    }
    
    static var secondaryColor: UIColor {
        return UIColor(r: 159, g: 65, b: 251)
    }
    
    static var tertiaryColor: UIColor {
        return .red
    }
    
    static var backgroundColor: UIColor {
        return .white
    }
    
}

extension UIImage {
    
    static var logo: UIImage? {
        return UIImage(named: "Logo")
    }
    
    static var logo_wireframe: UIImage? {
        return UIImage(named: "Logo-Wireframe")?.withRenderingMode(.alwaysTemplate)
    }
    
    static var coin: UIImage? {
        return UIImage(named: "Coin")
    }
    
    static var coin_wireframe: UIImage? {
        return UIImage(named: "Coin-Wireframe")?.withRenderingMode(.alwaysTemplate)
    }
    
    static var icon_shop: UIImage? {
        return UIImage(named: "Shop")
    }
    
    static var icon_user: UIImage? {
        return UIImage(named: "User")
    }
    
    static var icon_wallet: UIImage? {
        return UIImage(named: "Bank Card Back Side")
    }
    
    static var icon_bell: UIImage? {
        return UIImage(named: "Appointment Reminders")
    }
    
}

