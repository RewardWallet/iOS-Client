//
//  BusinessViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/8/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MapKit
import IGListKit

final class BusinessViewController: ListViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let business: Business
    
    fileprivate lazy var businessPageNavigationToken = BusinessPageNavSectionModel(pages: Array(iterateEnum(BusinessPage.self)), business: business)
 
    fileprivate var isLoading: Bool = false {
        didSet {
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    fileprivate let loadingToken: NSNumber = 10
    
    fileprivate lazy var transition = BubbleTransition(animatedView: self.subscribeButton)
    
    // MARK: - Subviews
    
    private let subscribeButton = RippleButton(style: Stylesheet.RippleButtons.primary) {
        $0.apply(Stylesheet.Views.lightlyShadowed)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.setTitle("+", for: .normal)
        $0.alpha = 0
    }
    
    // MARK: - Initialization
    
    init(for business: Business) {
        self.business = business
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.backgroundColor = .offWhite
        collectionView.contentInset.bottom = 100
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        view.addSubview(subscribeButton)
        subscribeButton.addTarget(self, action: #selector(addToWallet), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        checkIfCardExists()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
        let color = UIColor.primaryColor
        navigationController?.navigationBar.setBackgroundImage(color.toImage ?? UIImage(), for: .default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = 52
        subscribeButton.buttonCornerRadius = size / 2
        subscribeButton.frame = CGRect(x: view.bounds.width - size - 24,
                                       y: view.bounds.height - size - 24,
                                       width: size, height: size)
    }
    
    private func checkIfCardExists() {
        // Show the subscribe button if the user hasn't added the business to their wallet yet
        API.shared.fetchDigitalCard(for: business) { [weak self] (card) in
            let digitalCardExists = card != nil
            if !digitalCardExists {
                guard self?.subscribeButton.alpha == 0 else { return } // Don't reanimate
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self?.subscribeButton.alpha = 1
                    self?.subscribeButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.subscribeButton.transform = .identity
                    })
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.subscribeButton.alpha = 0
                    self?.subscribeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                })
            }
        }
    }
    
    // MARK: - User Actions
    
    @objc
    private func addToWallet() {
        guard let viewController = AppRouter.shared.viewController(for: .addToWallet, context: business) else { return }
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self.transition
        AppRouter.shared.present(viewController, from: self, animated: true, completion: nil)
    }
    
}

// MARK: - ListAdapterDataSource
extension BusinessViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [business, businessPageNavigationToken]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Business {
            return BusinessSectionController()
        } else if object is BusinessPageNavSectionModel {
            return BusinessPageNavSectionController()
        }
        fatalError()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - UIScrollViewDelegate
extension BusinessViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        guard yOffset >= 0 else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            return
        }
        let headerHeight = adapter.sizeForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)).height
        var alpha = yOffset / ((headerHeight/4) + 20)
        alpha = alpha < 0.994 ? alpha : 0.994 // Going to 1.0 makes it semi transparent due to isTranslucent = true
        let color = business.primaryColor.withAlphaComponent(alpha)
        navigationController?.navigationBar.setBackgroundImage(color.toImage ?? UIImage(), for: .default)
        let showTitles = yOffset >= (headerHeight/3)
        title = showTitles ? business.name : nil
        subtitle = showTitles ? business.address : nil
    }
    
}

