//
//  ExploreViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import MapKit

final class ExploreViewController: RWViewController {
    
    // MARK: - Properties
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let mapView = UIView() // Some background content
    
    fileprivate let searchToken: NSNumber = 123
    fileprivate var searchFilter: String = ""
    fileprivate let spinnerToken: NSNumber = 456
    
    fileprivate var isLoading: Bool = true {
        didSet {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Explore"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_shop?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_shop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.scrollIndicatorInsets.top = 200
//        collectionView.contentInset.top = 200
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        mapView.backgroundColor = .groupTableViewBackground // remove later
//        view.addSubview(mapView)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
//        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: collectionView.contentInset.top)
    }
    
}

// MARK: ListAdapterDataSource
extension ExploreViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [FeaturedSection(for: .recommended)]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        if let num = object as? NSNumber, num == searchToken {
//            let sectionController = SearchSectionController()
//            sectionController.delegate = self
//            return sectionController
//        } else if let num = object as? NSNumber, num == spinnerToken {
//            return SpinnerSectionController()
//        } else {
//            return LabelSectionController()
//        }
        return ExploreSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: SearchSectionControllerDelegate
extension ExploreViewController: SearchSectionControllerDelegate {
    
    func searchSectionController(_ sectionController: SearchSectionController, didChangeText text: String) {
        searchFilter = text
        adapter.performUpdates(animated: true, completion: nil)
    }
    
}

// MARK: UIScrollViewDelegate
extension ExploreViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !isLoading && distance < 200 {
            isLoading = true
            // Load new content here
            DispatchQueue.global(qos: .default).async {
                // fake background loading task
                sleep(2)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
}
