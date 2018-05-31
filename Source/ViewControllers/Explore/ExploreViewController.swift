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
import Parse

final class ExploreViewController: ListViewController {
    
    // MARK: - Properties
    
    fileprivate var timer: Timer? = nil
    fileprivate var filterText: String?
    fileprivate let searchToken: NSNumber = 123
    fileprivate var searchFilter: String = ""
    fileprivate let spinnerToken: NSNumber = 456
    fileprivate var isSearching: Bool = false {
        didSet {
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    // MARK: - Subviews
    
    private let headerView = SearchHeaderView()
 
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
        
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.sectionHeadersPinToVisibleBounds = true
        
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = rc
        
        headerView.viewController = self
        view.addSubview(headerView)
        headerView.searchBarDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            // Pushing a controller onto the stack
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerHeight: CGFloat = 64 + UIApplication.shared.statusBarFrame.height
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
        collectionView.frame = CGRect(x: 0, y: headerHeight, width: view.bounds.width, height: view.bounds.height - headerHeight)
    }
    
    @objc
    func handleRefresh() {
        adapter.performUpdates(animated: true) { [weak self] (_) in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    func updateSearchResults() {
        timer?.invalidate()
        // Make Search
    }
    
}

// MARK: ListAdapterDataSource
extension ExploreViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [FeaturedSection(for: .recommended), FeaturedSection(for: .recentlyAdded)]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
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
        
//        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
//        if !isLoading && distance < 200 {
//            isLoading = true
//            // Load new content here
//            DispatchQueue.global(qos: .default).async {
//                // fake background loading task
//                sleep(2)
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                }
//            }
//        }
    }
    
}

extension ExploreViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearching = false
        textField.text = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let newString = textField.text as NSString? else { return true }
        let newFilter = newString.replacingCharacters(in: range, with: string)
        filterText = newFilter
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSearchResults), userInfo: nil, repeats: false)
        
        return true
    }
    
}
