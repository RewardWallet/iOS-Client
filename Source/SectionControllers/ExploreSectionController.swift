//
//  ExploreSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class ExploreSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private var source: FeaturedSection?
    
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    fileprivate var isLoading: Bool = false {
        didSet {
            adapter.collectionView?.isScrollEnabled = !isLoading
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    fileprivate let loadingTokens: [NSNumber] = [10,20]
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        self.supplementaryViewSource = self
    }
    
    // MARK: - Methods
    
    override func didUpdate(to object: Any) {
        
        source = object as? FeaturedSection
        
        isLoading = true
        API.shared.fetchRecommendedBusinesses { [weak self] in
            self?.source?.fetchedBusinesses = $0
            self?.isLoading = false
        }
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 250)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else {
            fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
}

// MARK: - ListAdapterDataSource
extension ExploreSectionController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if isLoading {
            return loadingTokens
        }
        return source?.fetchedBusinesses ?? loadingTokens
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if isLoading {
            let configureBlock = { (item: Any, cell: UICollectionViewCell) in
                guard let cell = cell as? SpinnerCell else { return }
                cell.backgroundColor = .offWhite
                cell.apply(Stylesheet.Views.rounded)
                cell.activityIndicator.startAnimating()
            }
            
            let inset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
                guard let context = context else { return .zero }
                return CGSize(width: context.containerSize.width - 100 - inset.left - inset.right,
                              height: context.containerSize.height)
            }
            let sectionController = ListSingleSectionController(cellClass: SpinnerCell.self,
                                                                configureBlock: configureBlock,
                                                                sizeBlock: sizeBlock)
            sectionController.inset = inset
            return sectionController
        }
        return FeaturedBusinessSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - ListSupplementaryViewSource
extension ExploreSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: HeaderViewCell.self, at: index) as? HeaderViewCell else {
            fatalError()
        }
        view.title = source?.title
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 44)
        return size
    }
    
}
