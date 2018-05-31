//
//  BusinessHeaderView.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher
import ImageSlideshow

final class BusinessHeaderView: RWCollectionReusableView {
    
    // MARK: - Properties
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()
    
    fileprivate var categories: [String]? {
        didSet {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - Subviews
    
    private let slideshowImageView = UIImageView()
//        let view = ImageSlideshow()
//        view.backgroundColor = .primaryColor
//        view.slideshowInterval = 3
//        view.contentScaleMode = .scaleAspectFill
//        view.circular = true
//        view.activityIndicator = DefaultActivityIndicator()
//        return view
//    }()
    
    private let contentView = UIView(style: Stylesheet.Views.roundedShadowed) {
        $0.backgroundColor = .white
        $0.apply(Stylesheet.Views.farShadowed)
    }
    
    // MARK: - Subviews
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let titleLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.font = Stylesheet.headerFont.withSize(26)
    }
    
    private let addressLabel = UILabel(style: Stylesheet.Labels.address) {
        $0.font = Stylesheet.descriptionFont.withSize(16)
    }
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.rating = 4
        view.editable = false
        view.fullImage = .iconStarFilled
        view.emptyImage = .iconStar
        view.tintColor = .lightGray
        view.minImageSize = CGSize(width: 25, height: 25)
        view.imageContentMode = .scaleAspectFit
        return view
    }()
    
    private let ratingLabel = UILabel(style: Stylesheet.Labels.caption) {
        $0.attributedText = NSMutableAttributedString().bold("4.6", size: 15, color: .yellowColor).normal(" (13 Reviews)", font: Stylesheet.captionFont, color: .grayColor)
    }
    
    fileprivate var contentViewConstraints: [NSLayoutConstraint]?
    
    override func setupView() {
        
        backgroundColor = .offWhite
        addSubview(slideshowImageView)
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(ratingView)
        contentView.addSubview(ratingLabel)
        
        collectionView.contentInset.left = 16
        collectionView.contentInset.right = 16
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        slideshowImageView.anchor(topAnchor, left: leftAnchor, bottom: contentView.centerYAnchor, right: rightAnchor)
        
        contentViewConstraints = contentView.anchor(centerYAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 24, rightConstant: 24)
        
        titleLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 36)
        
        addressLabel.anchorBelow(titleLabel, topConstant: 6, heightConstant: 15)
        
        collectionView.anchor(addressLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 12, heightConstant: 30)
        
        ratingView.anchor(collectionView.bottomAnchor, left: titleLabel.leftAnchor, topConstant: 12, widthConstant: 125, heightConstant: 25)
        ratingLabel.anchorRightOf(ratingView, right: contentView.rightAnchor, leftConstant: 6, rightConstant: 12)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(presentImageSlideshow))
        slideshowImageView.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Stretchy Scale API
    
    func stretchImageView(to scale: CGFloat, offsetBy offset: CGFloat) {
        if offset <= 0 {
            let translation = offset/2
            slideshowImageView.transform = CGAffineTransform(translationX: 0, y: translation).scaledBy(x: scale, y: scale)
            adjustContentView(to: 0)
        } else if offset <= 150 {
            // scollViewDidScroll(_:) does not reach exactly 100 all the time when scrolled fast
            let adjustedOffset = offset >= 100 ? 100 : offset
            adjustContentView(to: adjustedOffset)
        }
    }
    
    private func adjustContentView(to offset: CGFloat) {
        let factor = (offset / 100)
        contentView.layer.cornerRadius = 8 - (factor*8)
        contentView.layer.shadowOpacity = Float(0.5 - (factor*0.5))
        contentViewConstraints?.forEach {
            if $0.identifier == "left" {
                $0.constant = 24 - (factor*24)
            } else if $0.identifier == "right" {
                $0.constant = -(24 - (factor*24))
            } else if $0.identifier == "bottom" {
                $0.constant = -(24 - (factor*24))
            }
        }
    }
    
    @objc
    func presentImageSlideshow() {
//        guard !slideshowImageView.images.isEmpty else { return }
//        guard let viewController = UIApplication.shared.presentedController else { return }
//        let fullScreenController = slideshowImageView.presentFullScreenController(from: viewController)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}

// MARK: - ListBindable
extension BusinessHeaderView: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let business = viewModel as? Business else { return }
        titleLabel.text = business.name
        categories = business.categories
        addressLabel.text = business.address
        ratingView.rating = business.rating?.doubleValue ?? 4
        slideshowImageView.kf.setImage(with: business.image)
//        if let urlString = business.image?.url, let url = URL(string: urlString) {
//            slideshowImageView.setImageInputs([KingfisherSource(url: url)])
//        }
    }
    
}

// MARK: - ListAdapterDataSource
extension BusinessHeaderView: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (categories ?? []).map { $0 as ListDiffable }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let configureBlock = { (item: Any, cell: UICollectionViewCell) in
            guard let cell = cell as? LabelCell else { return }
            cell.contentView.backgroundColor = .offWhite
            cell.contentView.layer.cornerRadius = 4
            cell.label.textColor = .darkGray
            cell.bindViewModel(object)
        }
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
            guard let size = context?.containerSize else { return .zero }
            return CGSize(width: 80 - inset.right, height: size.height)
        }
        let sectionController = ListSingleSectionController(cellClass: LabelCell.self,
                                                            configureBlock: configureBlock,
                                                            sizeBlock: sizeBlock)
        sectionController.inset = inset
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
