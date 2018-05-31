//
//  WriteReviewViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 5/5/18.
//  Copyright © 2018 Amanda Hille. All rights reserved.
//

import UIKit

protocol WriteReviewDelegate: class {
    func didAddReview(_ review: Review)
}

final class WriteReviewViewController: RWViewController {
    
    weak var delegate: WriteReviewDelegate?
    
    private let business: Business
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.fullImage = .iconStarFilled
        view.emptyImage = .iconStar
        view.minImageSize = CGSize(width: 30, height: 30)
        view.imageContentMode = .scaleAspectFit
        return view
    }()
    
    private let textView = InputTextView()
    
    init(for business: Business) {
        self.business = business
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Review"
//        subtitle = bu
        
        textView.placeholder = "Add your review..."
        view.addSubview(textView)
        
        view.addSubview(ratingView)
        
        ratingView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        textView.anchor(ratingView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(promptSend))
    }
    
    @objc
    func promptSend() {
        
        let alertViewController = AlertViewController(title: "Submit Review?", message: "Reviews cannot be edited or removed", action: Action(title: "Submit", style: .default, callback: { [weak self] _ in
            self?.sendReview()
        }))
        present(alertViewController, animated: true, completion: nil)
    }
    
    @objc
    func sendReview() {
        
        guard ratingView.rating > 0 else {
//            handleError("Please provide a rating")
            return
        }
        
    }
    
}
