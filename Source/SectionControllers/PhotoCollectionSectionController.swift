//
//  PhotoCollectionSectionController.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class PhotoCollectionSectionController: ListSectionController {
    
    // MARK: - Properties
    
    private var imageCollectionModel: ImageCollectionViewModel?
    
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func didUpdate(to object: Any) {
        imageCollectionModel = object as? ImageCollectionViewModel
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 180)
        return CGSize(width: size.width - inset.right - inset.left,
                      height: size.height - inset.top - inset.bottom)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else {
            fatalError()
        }
        adapter.collectionView = cell.collectionView
//        cell.apply(Stylesheet.Views.rounded)
//        cell.apply(Stylesheet.Views.farShadowed)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
}

// MARK: - ListAdapterDataSource
extension PhotoCollectionSectionController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return imageCollectionModel?.files ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PhotoSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - ListSupplementaryViewSource
extension PhotoCollectionSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: HeaderViewCell.self, at: index) as? HeaderViewCell else {
            fatalError()
        }
        view.title = "PHOTOS"
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        return CGSize(width: width, height: 44)
    }
    
}
