//
//  BusinessSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class BusinessSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private weak var business: Business?
    
    // MARK: - Subview Reference
    
    weak fileprivate var headerView: BusinessHeaderView?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        supplementaryViewSource = self
        scrollDelegate = self
    }
    
    override func didUpdate(to object: Any) {
        business = object as? Business
    }
    
    override func numberOfItems() -> Int {
        return 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
}

// MARK: - ListSupplementaryViewSource
extension BusinessSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        
        // Stretchy Header
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: BusinessHeaderView.self, at: index) as? BusinessHeaderView else {
            fatalError()
        }
        view.bindViewModel(business as Any)
        headerView = view
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        // Stretchy Banner
        return CGSize(width: containerSize.width, height: 400)
    }
    
}

// MARK: - ListScrollDelegate
extension BusinessSectionController: ListScrollDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, didScroll sectionController: ListSectionController) {
        
        guard let collectionView = listAdapter.collectionView else { return }
        let yOffset = collectionView.contentOffset.y + collectionView.contentInset.top
        
        let headerHeight = (sizeForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: 0).height - 24) * 0.75
        let scale: CGFloat = 1 - (yOffset/headerHeight)
        headerView?.stretchImageView(to: scale, offsetBy: yOffset)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willBeginDragging sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDragging sectionController: ListSectionController, willDecelerate decelerate: Bool) {
        
    }
    
}
