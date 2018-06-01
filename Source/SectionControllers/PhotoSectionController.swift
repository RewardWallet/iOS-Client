//
//  PhotoSectionController.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Parse

final class PhotoSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private var file: PFFile?

    // MARK: - Initialization
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    }
    
    override func didUpdate(to object: Any) {
        file = object as? PFFile
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width - 50, height: collectionContext!.containerSize.height)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: PhotoCell.self, for: self, at: index) as? PhotoCell else {
            fatalError()
        }
        cell.bindViewModel(file as Any)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func didHighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [.allowUserInteraction, .curveEaseOut], animations: {
            cell.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    override func didUnhighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 0.15) {
            cell.contentView.transform = .identity
        }
    }
    
}
