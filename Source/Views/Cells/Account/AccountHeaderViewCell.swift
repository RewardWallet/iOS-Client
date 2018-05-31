//
//  AccountHeaderViewCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

final class AccountHeaderViewCell: RWCollectionReusableView {
    
    // MARK: - Subviews
    
    private let backgroundImageView = UIImageView(style: Stylesheet.ImageViews.filled) {
        $0.clipsToBounds = true
        $0.backgroundColor = .primaryColor
    }
    
    private let backgroundImageViewOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        return view
    }()
    
    private let profileImageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare) {
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = UIColor.primaryColor.darker()
    }
    
    private let nameLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let nameLabelBackground: GradientView = {
        let view = GradientView()
        view.colors = [.primaryColor, UIColor.primaryColor.darker(by: 3)]
        view.locations = [0, 0.4]
        return view
    }()
    
    override func setupView() {
        
        backgroundColor = .primaryColor
        apply(Stylesheet.Views.lightlyShadowed)
        
        addSubview(backgroundImageView)
        addSubview(backgroundImageViewOverlay)
        addSubview(nameLabelBackground)
        addSubview(profileImageView)
        nameLabelBackground.addSubview(nameLabel)
        
        backgroundImageView.anchor(topAnchor, left: leftAnchor, bottom: profileImageView.centerYAnchor, right: rightAnchor)
        backgroundImageViewOverlay.anchor(topAnchor, left: leftAnchor, bottom: profileImageView.centerYAnchor, right: rightAnchor)
        
        profileImageView.anchorCenterXToSuperview()
        profileImageView.anchor(bottom: bottomAnchor, bottomConstant: 50, widthConstant: 100, heightConstant: 100)
        
        nameLabelBackground.anchor(profileImageView.centerYAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        nameLabel.anchor(profileImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, bottomConstant: 3)
    }
    
    // MARK: - Stretchy Scale API
    
    func stretchImageView(to scale: CGFloat, offsetBy offset: CGFloat) {
        backgroundImageView.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: offset/2))
        backgroundImageViewOverlay.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: offset/2))
        let alpha = sqrt(1 - abs(offset / bounds.height / 3))
        backgroundImageViewOverlay.alpha = alpha < 1 ? alpha : 1
    }
    
}

extension AccountHeaderViewCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let user = viewModel as? User else { return }
        nameLabel.text = user.fullname ?? user.username
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: user.picture)
    }
    
}
