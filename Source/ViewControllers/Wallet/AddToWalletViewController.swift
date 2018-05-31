//
//  AddToWalletViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-05-27.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class AddToWalletViewController: RWViewController {
    
    // MARK: - Properties
    
    private let business: Business
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private var digitalCardViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Subviews
    
    private let digitalCardView = DigitalCardView()
    
    private let cancelButton = UIButton(style: Stylesheet.Buttons.link) {
        $0.setTitle("No thanks, take me back", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(UIColor.gray.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(AddToWalletViewController.dismissViewController), for: .touchUpInside)
    }
    
    private let addButton = RippleButton(style: Stylesheet.RippleButtons.primary) {
        $0.setTitle("Add to Wallet", for: .normal)
        $0.trackTouchLocation = true
        $0.buttonCornerRadius = 12
        $0.addTarget(self, action: #selector(AddToWalletViewController.addToWallet), for: .touchUpInside)
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
        
        digitalCardView.digitalCard = DigitalCard(business: business, user: nil)
        
        view.addSubview(addButton)
        view.addSubview(cancelButton)
        view.addSubview(digitalCardView)
        
        digitalCardViewBottomConstraint = digitalCardView.anchor(nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 220)[1]
        digitalCardView.anchorCenterXToSuperview()
        addButton.anchor(nil, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 64, bottomConstant: 64, rightConstant: 64, widthConstant: 0, heightConstant: 44)
        cancelButton.anchorBelow(addButton, bottom: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 20)
    }
    
    // MARK: - User Action
    
    @objc
    func addToWallet() {
        
        let digitalCard = DigitalCard(business: business, user: User.current())
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        digitalCard.saveInBackground { (success, error) in
            API.shared.dismissProgressHUD()
            guard success else {
                return self.handleError(error?.localizedDescription)
            }
            self.animateAdditionAndDismiss()
        }
    }
    
    @objc
    func animateAdditionAndDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            // Slide the card off frame towards the bottom
            self.digitalCardViewBottomConstraint?.constant = ((self.view.bounds.height / 2) + self.digitalCardView.bounds.height)
            self.addButton.alpha = 0
            self.cancelButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
