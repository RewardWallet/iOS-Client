//
//  BusinessPageNavSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-05-30.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import IGListKit

enum BusinessPage: String {
    
    case details = "Details"
    case rewards = "Rewards"
    case coupons = "Coupons"
    case reviews = "Reviews"
    
    var image: UIImage? {
        switch self {
        case .details:
            return UIImage.iconBusinessDetails
        case .rewards:
            return UIImage.iconCoins
        case .coupons:
            return UIImage.iconCoupons
        case .reviews:
            return UIImage.iconReview
        }
    }

}

final class BusinessPageNavSectionModel: ListDiffable {
    
    let pages: [BusinessPage]
    weak var business: Business?
    
    init(pages: [BusinessPage], business: Business?) {
        self.pages = pages
        self.business = business
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return pages.map { return $0.rawValue }.joined(separator: "-") as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let model = object as? BusinessPageNavSectionModel else { return false }
        return model.pages == pages
    }
    
}

protocol BusinessPageNavSectionControllerDelegate: class {
    func pageNavSectionController(_ sectionController: ListSectionController, didSelectPage page: BusinessPage)
}

final class BusinessPageNavSectionController: ListSectionController {
    
    // MARK: - Properties
    
    weak var delegate: BusinessPageNavSectionControllerDelegate?
    
    fileprivate weak var model: BusinessPageNavSectionModel?
    
    fileprivate lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func didUpdate(to object: Any) {
        self.model = object as? BusinessPageNavSectionModel
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else { fatalError() }
        cell.backgroundColor = model?.business?.primaryColor
        cell.collectionView.alwaysBounceHorizontal = false
        cell.collectionView.contentInset.left = 16
        cell.collectionView.contentInset.right = 16
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 52)
    }
    
}

extension BusinessPageNavSectionController: ListAdapterDataSource, ListSingleSectionControllerDelegate {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return model?.pages.map { $0.rawValue as ListDiffable } ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let inset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        let sectionController = ListSingleSectionController(cellClass: BusinessPageCell.self, configureBlock: { (object, cell) in
            let businessPageCell = cell as? BusinessPageCell
            guard let pageRawValue = object as? String else { return }
            businessPageCell?.page = BusinessPage(rawValue: pageRawValue)
        }) { (object, context) -> CGSize in
            return CGSize(width: (context!.containerSize.width * 0.4) - inset.left - inset.right,
                          height: context!.containerSize.height - inset.top - inset.bottom)
        }
        sectionController.inset = inset
        sectionController.selectionDelegate = self
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
        guard let text = object as? String, let page = BusinessPage(rawValue: text) else { return }
        delegate?.pageNavSectionController(self, didSelectPage: page)
    }
    
}
