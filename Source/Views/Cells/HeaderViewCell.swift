//
//  HeaderViewCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class HeaderViewCell: RWCollectionReusableView {
    
    // MARK: - Properties
    
    var title: String? {
        didSet {
            headerLabel.text = title
        }
    }
    
    // MARK: - Subviews
    
    private let headerLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.textColor = .primaryColor
    }
    
    override func setupView() {
        
        backgroundColor = .white
        apply(Stylesheet.Views.farShadowed)
        addSubview(headerLabel)
        headerLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 12, bottomConstant: 6, rightConstant: 12)
    }
    
}
