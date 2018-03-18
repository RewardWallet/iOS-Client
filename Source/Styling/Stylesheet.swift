//
//  AppRouter.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/5/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

enum Stylesheet {
    
    static var titleFont: UIFont {
        return .boldSystemFont(ofSize: 34)
    }
    
    static var subtitleFont: UIFont {
        return .systemFont(ofSize: 28, weight: .semibold)
    }
    
    static var headerFont: UIFont {
        return .systemFont(ofSize: 16, weight: .medium)
    }
    
    static var subheaderFont: UIFont {
        return .systemFont(ofSize: 14, weight: .medium)
    }
    
    static var descriptionFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    static var buttonFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    static var captionFont: UIFont {
        return .systemFont(ofSize: 13)
    }
    
    static var footnoteFont: UIFont {
        return .systemFont(ofSize: 12, weight: .medium)
    }
    
    enum Labels {
        
        static let title = Style<UILabel> {
            $0.font = titleFont
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let subtitle = Style<UILabel> {
            $0.font = subtitleFont
            $0.textColor = .darkGray
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let header = Style<UILabel> {
            $0.font = headerFont
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let subheader = Style<UILabel> {
            $0.font = subheaderFont
            $0.textColor = .darkGray
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let light = Style<UILabel> {
            $0.font = UIFont.systemFont(ofSize: 28, weight: .light)
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let description = Style<UILabel> {
            $0.font = descriptionFont
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let address = Style<UILabel> {
            $0.font = descriptionFont.withSize(12)
            $0.textColor = .darkGray
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let caption = Style<UILabel> {
            $0.font = captionFont
            $0.textColor = .darkGray
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let footnote = Style<UILabel> {
            $0.font = footnoteFont
            $0.textColor = .darkGray
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
    }
    
    enum Views {
        
        static let rounded = Style<UIView> {
            $0.layer.cornerRadius = 8
        }
        
        static let lightlyShadowed = Style<UIView> {
            $0.layer.shadowColor = UIColor.shadowColor.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 2
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        static let shadowed = Style<UIView> {
            $0.layer.shadowColor = UIColor.shadowColor.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 3
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
        
        static let roundedShadowed = Style<UIView> {
            $0.apply(Stylesheet.Views.shadowed)
            $0.apply(Stylesheet.Views.rounded)
        }
        
        static let roundedLightlyShadowed = Style<UIView> {
            $0.apply(Stylesheet.Views.lightlyShadowed)
            $0.apply(Stylesheet.Views.rounded)
        }
        
        static let farShadowed = Style<UIView> {
            $0.layer.shadowRadius = 5
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
    
    enum ImageViews {
        
        static let fitted = Style<UIImageView> {
            $0.tintColor = .grayColor
            $0.contentMode = .scaleAspectFit
        }
        
        static let filled = Style<UIImageView> {
            $0.tintColor = .offWhite
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .backgroundColor
            $0.clipsToBounds = true
        }
        
        static let roundedSquare = Style<UIImageView> {
            $0.tintColor = .offWhite
            $0.apply(Stylesheet.Views.rounded)
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .backgroundColor
        }
    }
    
    enum NavigationBars {
        
        static let primary = Style<UINavigationBar> {
            $0.barTintColor = .primaryColor
            $0.tintColor = .white
            $0.barStyle = .black
            $0.isTranslucent = false
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
        
        static let inversePrimary = Style<UINavigationBar> {
            $0.barTintColor = .white
            $0.tintColor = .primaryColor
            $0.barStyle = .default
            $0.isTranslucent = false
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
        
        static let clear = Style<UINavigationBar> {
            $0.barTintColor = .white
            $0.tintColor = .primaryColor
            $0.barStyle = .default
            $0.isTranslucent = true
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
    }
    
    enum Buttons {
        
        static let primary = Style<UIButton> {
            $0.backgroundColor = .primaryColor
            let titleColor: UIColor = UIColor.primaryColor.isLight ? .black : .white
            $0.titleLabel?.font = buttonFont
            $0.setTitleColor(titleColor, for: .normal)
            $0.setTitleColor(titleColor.withAlphaComponent(0.3), for: .highlighted)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
        
        static let secondary = Style<UIButton> {
            $0.backgroundColor = .secondaryColor
            let titleColor: UIColor = UIColor.secondaryColor.isLight ? .black : .white
            $0.titleLabel?.font = buttonFont
            $0.setTitleColor(titleColor, for: .normal)
            $0.setTitleColor(titleColor.withAlphaComponent(0.3), for: .highlighted)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
        
        static let link = Style<UIButton> {
            $0.contentHorizontalAlignment = .left
            let titleColor: UIColor = UIColor.primaryColor
            $0.titleLabel?.font = buttonFont
            $0.setTitleColor(titleColor, for: .normal)
            $0.setTitleColor(titleColor.withAlphaComponent(0.3), for: .highlighted)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
        
        static let roundedWhite = Style<UIButton> {
            $0.layer.cornerRadius = 22
            $0.backgroundColor = .white
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        }
        
    }
}
