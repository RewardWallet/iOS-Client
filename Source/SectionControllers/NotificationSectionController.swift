//
//  NotificationSectionController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-21.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class NotificationSectionController: ListSectionController {
    
    private weak var notification: ActivityNotification?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 44)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: LabelCell.self, for: self, at: index) as? LabelCell else {
            fatalError()
        }
        cell.label.text = notification?.text
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.notification = object as? ActivityNotification
    }
    
}


