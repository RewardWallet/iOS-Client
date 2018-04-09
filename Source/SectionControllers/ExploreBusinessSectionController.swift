//
//  FeaturedBusinessSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/25/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class FeaturedBusinessSectionController: ListSectionController {
    
    private var business: Business?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    override func didUpdate(to object: Any) {
        business = object as? Business
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width - 100, height: collectionContext!.containerSize.height)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: BusinessViewCell.self, for: self, at: index) as? BusinessViewCell else {
            fatalError()
        }
        cell.bindViewModel(business as Any)
        return cell
    }

    override func didSelectItem(at index: Int) {

//        AppRouter.shared.push(.business, context: business, from: viewController?.navigationController, animated: true)
//        let alert = UIAlertController(title: "Add to Wallet", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
//            guard let business = self.business else { return }
//            User.current()?.addDigitalCard(for: business, completion: { (success, error) in
//                print(success)
//            })
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        viewController?.present(alert, animated: true, completion: nil)
    }
    
    override func didHighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [.allowUserInteraction, .curveEaseOut], animations: {
            cell.contentView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: nil)
    }
    
    override func didUnhighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 0.3) {
            cell.contentView.transform = .identity
        }
    }
    
}
