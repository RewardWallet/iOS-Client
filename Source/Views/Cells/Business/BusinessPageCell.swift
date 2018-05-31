//
//  BusinessPageCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-05-30.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

final class BusinessPageCell: RWCollectionViewCell {
    
    // MARK: - Properties
    
    var page: BusinessPage? {
        didSet {
            label.text = page?.rawValue
            imageView.image = page?.image
        }
    }
    
    // MARK: - Subviews
    
    private let roundedView = RoundedView()
    
    private let imageView = UIImageView(style: Stylesheet.ImageViews.fitted)
    
    private let label = UILabel(style: Stylesheet.Labels.subheader) {
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    // MARK: - Methods [Public]
    
    override func setupView() {
        super.setupView()

        backgroundColor = .clear
        roundedView.backgroundColor = .white
        contentView.addSubview(roundedView)
        roundedView.addSubview(label)
        roundedView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        roundedView.frame = UIEdgeInsetsInsetRect(bounds, insets)
        let height = (roundedView.frame.height - 8)
        imageView.frame = CGRect(origin: CGPoint(x: roundedView.frame.origin.x + 8, y: roundedView.frame.origin.y + 4),
                                 size: CGSize(width: height, height: height))
        label.frame = CGRect(origin: CGPoint(x: imageView.frame.maxX, y: roundedView.frame.origin.y + 4),
                             size: CGSize(width: roundedView.frame.width - 16 - height, height: height))
    }
    
}

