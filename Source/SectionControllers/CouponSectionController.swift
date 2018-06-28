//
//  CouponSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-21.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class CouponSectionController: ListSectionController {
    
    private var coupon: Coupon?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    override func didUpdate(to object: Any) {
        coupon = object as? Coupon
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width / 2, height: collectionContext!.containerSize.height)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CouponCell.self, for: self, at: index) as? CouponCell else {
            fatalError()
        }
        cell.bindViewModel(coupon as Any)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
//        AppRouter.shared.push(.business, context: business, from: viewController?.navigationController, animated: true)
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

