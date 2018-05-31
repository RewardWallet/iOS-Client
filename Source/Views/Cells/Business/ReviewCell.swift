//
//  ReviewCell.swift
//  Shared
//
//  Created by Nathan Tannar on 1/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

final class ReviewCell: RWCollectionViewCell {
    
    // MARK: - Properties

    private let profileImageView = UIImageView(style: Stylesheet.ImageViews.filled)
    
    private let profileLabel = UILabel(style: Stylesheet.Labels.header)
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.rating = 4
        view.editable = false
        view.fullImage = #imageLiteral(resourceName: "ic_star_filled")
        view.emptyImage = #imageLiteral(resourceName: "ic_star")
        view.minImageSize = CGSize(width: 20, height: 20)
        view.imageContentMode = .scaleAspectFit
        return view
    }()
    
    private var ratingLabel = UILabel(style: Stylesheet.Labels.description) {
        $0.text = "No Description Provided"
    }
    
    // MARK: - Methods [Public]
    
    override func setupView() {
        super.setupView()
        addSubview(profileImageView)
        addSubview(profileLabel)
        addSubview(ratingView)
        addSubview(ratingLabel)
        
        profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        profileImageView.layer.cornerRadius = 20
        
        profileLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        
        ratingView.anchor(profileLabel.bottomAnchor, left: profileLabel.leftAnchor, bottom: nil, widthConstant: 100, heightConstant: 20)
        
        ratingLabel.anchor(ratingView.bottomAnchor, left: ratingView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 6, bottomConstant: 6, rightConstant: 8)
    }
}

extension ReviewCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let review = viewModel as? Review else { return }
//        profileImageView.kf.setImage(with: review.user?.picture)
//        profileLabel.text = review.user?.fullname
        ratingView.rating = review.rating?.doubleValue ?? 4
        ratingLabel.text = review.text
    }
    
}
