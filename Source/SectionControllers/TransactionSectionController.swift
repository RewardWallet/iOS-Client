//
//  TransactionSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 4/9/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class TransactionSectionController: ListSectionController {
    
    private weak var transaction: Transaction?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 44)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: LabelCell.self, for: self, at: index) as? LabelCell else {
            fatalError()
        }
        cell.label.text = transaction.debugDescription
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.transaction = object as? Transaction
    }
    
}

