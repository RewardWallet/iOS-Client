//
//  BusinessDetailsSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-05-31.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

class BusinessDetailsViewModel: ListDiffable {
    
    let business: Business
    
    init(for business: Business) {
        self.business = business
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(business.objectId ?? "")-details" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let model = object as? BusinessDetailsViewModel else { return false }
        return model.business.objectId == business.objectId
    }
    
}

final class BusinessDetailsSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private weak var business: Business?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func didUpdate(to object: Any) {
        business = object as? Business
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: LabelCell.self, for: self, at: index) as? LabelCell else { fatalError() }
        cell.backgroundColor = .white
        cell.label.text = business?.about ?? "No Description Provided"
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    
}

// MARK: - ListSupplementaryViewSource
extension BusinessDetailsSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: HeaderViewCell.self, at: index) as? HeaderViewCell else {
            fatalError()
        }
        view.title = "DETAILS"
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        return CGSize(width: width, height: 44)
    }
    
}
