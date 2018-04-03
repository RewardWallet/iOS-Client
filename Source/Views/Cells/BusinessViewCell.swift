//
//  BusinessViewCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class BusinessViewCell: RWCollectionViewCell {
    
    // MARK: - Subviews
    
    private let imageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare) {
        $0.backgroundColor = .secondaryColor
    }
    
    private let nameLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.text = "Business Name"
    }
    
    private let categoryLabel = UILabel(style: Stylesheet.Labels.subheader) {
        $0.text = "Category"
    }
    
    private let addressLabel = UILabel(style: Stylesheet.Labels.address) {
        $0.text = "Address"
    }
    
    private let captionLabel = UILabel(style: Stylesheet.Labels.caption) {
        $0.text = "A short description"
    }
    
    private let rewardModelLabel = UILabel(style: Stylesheet.Labels.footnote) {
        $0.text = "Cash Back"
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
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, categoryLabel, addressLabel, captionLabel, rewardModelLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 2
        contentView.addSubview(stackView)
        stackView.anchor(imageViewContainer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 4, rightConstant: 4)
    }
    
}

extension BusinessViewCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let business = viewModel as? Business else { return }
        nameLabel.text = business.name
        categoryLabel.text = business.email
        addressLabel.text = business.address
        captionLabel.text = business.about
    }
    
}
