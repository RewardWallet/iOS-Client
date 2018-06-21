//
//  SearchResultSectionController.swift
//  UserClient
//
//  Created by Nathan Tannar on 2/22/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class SearchResultSectionController: ListSectionController {
    
    weak var business: Business?
    
    override func didUpdate(to object: Any) {
        business = object as? Business
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchResultCell.self, for: self, at: index) as? SearchResultCell else {
            fatalError()
        }

        cell.imageView.kf.indicatorType = .activity
        let urlString = business?.image?.url ?? ""
        if let url = URL(string: urlString) {
            cell.imageView.kf.setImage(with: url)
        }
        cell.titleLabel.text = business?.name
        cell.subtitleLabel.text = business?.address
        
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
        AppRouter.shared.push(.business, context: business, from: viewController?.navigationController, animated: true)
    }
    
}


