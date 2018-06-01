//
//  RestaurantMapSectionController.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import Parse

final class MapSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private var geoPoint: PFGeoPoint?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func didUpdate(to object: Any) {
        geoPoint = object as? PFGeoPoint
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 160)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: LocationCell.self, for: self, at: index) as? LocationCell else {
            fatalError()
        }
        if let point = geoPoint {
            cell.plotGeoPoint(point)
        }
        return cell
    }
    
}

// MARK: - ListSupplementaryViewSource
extension MapSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: HeaderViewCell.self, at: index) as? HeaderViewCell else {
            fatalError()
        }
        view.title = "LOCATION"
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        return CGSize(width: width, height: 44)
    }
    
}
