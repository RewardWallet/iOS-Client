//
//  PhotoCell.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Parse
import Kingfisher

final class PhotoCell: RWCollectionViewCell {
    
    // MARK: - Subviews
    
    private let imageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare)
    
    // MARK: - Setup
    
    override func setupView() {
        
        apply(Stylesheet.Views.rounded)
        backgroundColor = .white
        
        let imageViewContainer = UIView() //(style: Stylesheet.Views.roundedLightlyShadowed)
        imageViewContainer.addSubview(imageView)
        imageView.fillSuperview()
        contentView.addSubview(imageViewContainer)
        imageViewContainer.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 4, bottomConstant: 8, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
}

// MARK: - ListBindable
extension PhotoCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let file = viewModel as? PFFile else { return }
        imageView.kf.setImage(with: file)
    }
    
}
