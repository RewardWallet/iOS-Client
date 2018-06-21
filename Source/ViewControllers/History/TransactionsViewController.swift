//
//  TransactionsViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-13.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

class TransactionsViewController: RWViewController {
    
    // MARK: - Properties
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let spinnerToken: NSNumber = 456
    
    fileprivate var isLoading: Bool = true {
        didSet {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    fileprivate var transactions = [Transaction]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transactions"
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = rc
        handleRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc
    func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        isLoading = true
        API.shared.fetchTransactions { [weak self] in
            self?.transactions = $0
            self?.isLoading = false
        }
    }
    
}

// MARK: ListAdapterDataSource
extension TransactionsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if isLoading {
            return [spinnerToken]
        }
        return transactions
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let num = object as? NSNumber, num == spinnerToken {
            return SpinnerSectionController()
        }
        return TransactionSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}


// MARK: UIScrollViewDelegate
extension TransactionsViewController: UIScrollViewDelegate {
    
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
