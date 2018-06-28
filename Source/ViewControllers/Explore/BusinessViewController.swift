//
//  BusinessViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/8/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MapKit
import Parse
import IGListKit
import DeckTransition

final class BusinessViewController: ListViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let business: Business
 
    fileprivate var isLoading: Bool = false {
        didSet {
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    fileprivate var digitalCard: DigitalCard?
    
    fileprivate let loadingToken: NSNumber = 10
    
    fileprivate lazy var transition = BubbleTransition(animatedView: self.subscribeButton)
    
    // MARK: - Subviews
    
    private let subscribeButton = RippleButton(style: Stylesheet.RippleButtons.primary) {
        $0.apply(Stylesheet.Views.lightlyShadowed)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.setTitle("+", for: .normal)
        $0.alpha = 0
        $0.layer.cornerRadius = 30
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
        collectionView.backgroundColor = .white
        collectionView.contentInset.bottom = 100
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        view.addSubview(subscribeButton)
        subscribeButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 24, rightConstant: 24, widthConstant: 60, heightConstant: 60)
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
    
    private func checkIfCardExists() {
        // Show the subscribe button if the user hasn't added the business to their wallet yet
        API.shared.fetchDigitalCard(for: business) { [weak self] (card) in
            self?.digitalCard = card
            if card != nil {
                self?.subscribeButton.setImage(UIImage.icon_wallet?.withRenderingMode(.alwaysTemplate), for: .normal)
                self?.subscribeButton.setTitle(nil, for: .normal)
            }
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                self?.subscribeButton.alpha = 1
                self?.subscribeButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self?.subscribeButton.transform = .identity
                })
            })
        }
    }
    
    // MARK: - User Actions
    
    @objc
    private func addToWallet() {
        if let digitalCard = digitalCard {
            let transitionDelegate = DeckTransitioningDelegate()
            guard let detailViewController = AppRouter.shared.viewController(for: .redeem, context: digitalCard) else { return }
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = transitionDelegate
            AppRouter.shared.present(detailViewController, from: self, animated: true, completion: nil)
        } else {
            guard let viewController = AppRouter.shared.viewController(for: .addToWallet, context: business) else { return }
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self.transition
            AppRouter.shared.present(viewController, from: self, animated: true, completion: nil)
        }
    }
    
}

// MARK: - ListAdapterDataSource
extension BusinessViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [business, BusinessDetailsViewModel(for: business), CouponSectionModel(title: "Coupons", query: API.shared.availableCouponsQuery(for: business, for: User.current()!))]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Business {
            return BusinessSectionController()
        } else if object is BusinessDetailsViewModel {
            return BusinessDetailsSectionController()
        } else if object is PFGeoPoint {
            return MapSectionController()
        } else if object is CouponSectionModel {
            return CouponListSectionController()
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
        let color =  UIColor.primaryColor.withAlphaComponent(alpha)
        navigationController?.navigationBar.setBackgroundImage(color.toImage ?? UIImage(), for: .default)
        let showTitles = yOffset >= (headerHeight/3)
        title = showTitles ? business.name : nil
        subtitle = showTitles ? business.address : nil
    }
    
}

