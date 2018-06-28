//
//  SearchCell.swift
//  UserClient
//
//  Created by Nathan Tannar on 2/10/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true           
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .secondaryColor
        return view
    }()
    
    let titleLabel = UILabel(style: Stylesheet.Labels.header)
    
    let subtitleLabel = UILabel(style: Stylesheet.Labels.description)
    
    let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    private func setup() {
        
        backgroundColor = .white
        line.backgroundColor = .lightGray
        
        addSubview(line)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        imageView.apply(Stylesheet.Views.rounded)
        
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 6, leftConstant: 12, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView.anchorAspectRatio()
        
        titleLabel.anchor(imageView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.anchorHeightToItem(subtitleLabel)
    }
}


