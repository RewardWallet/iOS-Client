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
        return .boldSystemFont(ofSize: 18)
    }
    
    static var subtitleFont: UIFont {
        return .systemFont(ofSize: 16, weight: .semibold)
    }
    
    static var descriptionFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    static var buttonFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    static var footnoteFont: UIFont {
        return .systemFont(ofSize: 12, weight: .medium)
    }
    
    enum Labels {
        
        static let title = Style<UILabel> {
            $0.font = titleFont
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        static let subtitle = Style<UILabel> {
            $0.font = subtitleFont
            $0.textColor = .darkGray
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
            $0.font = descriptionFont
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
    
    enum ImageView {
        
        static let roundedSquare = Style<UIImageView> {
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .backgroundColor
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
        
    }
}
