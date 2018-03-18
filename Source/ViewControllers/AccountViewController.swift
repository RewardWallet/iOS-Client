//
//  AccountViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

class AccountViewController: RWViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    // MARK: - Subviews
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Account"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_user?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_user)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // If pushing a UIViewController onto the stack, unhide the UINavigationBar
        guard (navigationController?.viewControllers.count ?? 1) > 1 else { return }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

// MARK: - ListAdapterDataSource
extension AccountViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let user = User.current() else { return [] }
        return [user]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return AccountSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
