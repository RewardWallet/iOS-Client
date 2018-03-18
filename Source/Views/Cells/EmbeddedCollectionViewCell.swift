//
//  FeaturedSectionController.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import IGListKit
import UIKit

class EmbeddedCollectionViewCell: RWCollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }

}
