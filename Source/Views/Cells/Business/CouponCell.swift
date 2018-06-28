//
//  CouponCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-21.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

final class CouponCell: RWCollectionViewCell {
    
    // MARK: - Subviews
    
    private let imageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare) {
        $0.backgroundColor = .secondaryColor
    }
    
    private let descriptionLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.text = "Business Name"
    }
    
    private let expirationLabel = UILabel(style: Stylesheet.Labels.subheader) {
        $0.text = "Category"
    }
    
    // MARK: - Setup
    
    override func setupView() {
        
        apply(Stylesheet.Views.rounded)
        backgroundColor = .white
        
        let imageViewContainer = UIView() //(style: Stylesheet.Views.roundedLightlyShadowed)
        imageViewContainer.addSubview(imageView)
        imageView.fillSuperview()
        contentView.addSubview(imageViewContainer)
        imageViewContainer.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        NSLayoutConstraint.activate([imageViewContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)])
        
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, expirationLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 2
        contentView.addSubview(stackView)
        stackView.anchor(imageViewContainer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 4, rightConstant: 4)
    }
    
}

extension CouponCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let coupon = viewModel as? Coupon else { return }
        descriptionLabel.text = coupon.text
        expirationLabel.text = "Expires: " + (coupon.expireDate?.string(dateStyle: .medium, timeStyle: .none) ?? "Today")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: coupon.image)
    }
    
}
