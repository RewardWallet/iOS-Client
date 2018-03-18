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
    
    static var greenColor: UIColor {
        return UIColor(hex: "43A047") // Material Green 600
    }
    
    static var redColor: UIColor {
        return UIColor(hex: "D32F2F") // Material Red 700
    }
    
    static var grayColor: UIColor {
        return UIColor(hex: "9E9E9E") // Material Gray 500
    }
    
    static var shadowColor: UIColor {
        return UIColor(hex: "757575") // Material Gray 600
    }
    
    static var offWhite: UIColor {
        return UIColor(white: 0.96, alpha: 1)
    }
    
    static var orangeColor: UIColor {
        return UIColor(r: 245, g: 134, b: 49)
    }
    
    static var yellowColor: UIColor {
        return UIColor(r: 254, g: 201, b: 62)
    }
    
    static var backgroundColor: UIColor {
        return .white
    }
    
    static var facebookBlue: UIColor {
        return UIColor(hex: "3b5998")
    }
    
    static var googleOffWhite: UIColor {
        return UIColor(hex: "EEEEEE")
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
    
    static var icon_logOut: UIImage? {
        return UIImage(named: "Logout")
    }
    
    static var icon_wallet: UIImage? {
        return UIImage(named: "Bank Card Back Side")
    }
    
    static var icon_about: UIImage? {
        return UIImage(named: "About")
    }
    
    static var icon_bell: UIImage? {
        return UIImage(named: "Appointment Reminders")
    }
    
    static var iconStar: UIImage? {
        return UIImage(named: "icon-star")
    }
    
    static var iconStarFilled: UIImage? {
        return UIImage(named: "icon-star-filled")
    }
    
}

