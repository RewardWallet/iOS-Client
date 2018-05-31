//
//  TermsOfServiceViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/10/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class TermsOfServiceViewController: RWViewController {
    
    // MARK: - Subviews
    
    private let textView = UITextView(style: Stylesheet.TextViews.nonEditable) {
        if let file = Bundle.main.path(forResource: "EndUserLicenseAgreement", ofType: "html") {
            if let data = try? String(contentsOfFile: file).data(using: .unicode, allowLossyConversion: true) {
                $0.attributedText = try? NSAttributedString(data: data!,
                                                            options: [.documentType : NSAttributedString.DocumentType.html],
                                                            documentAttributes: nil)
            }
        }
    }
    
    private let doneButton = RippleButton(style: Stylesheet.Buttons.primary) {
        $0.setTitle("Done", for: .normal)
        $0.apply(Stylesheet.Views.roundedShadowed)
        $0.layer.cornerRadius = 22
        $0.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RewardWallet"
        subtitle = "End-User License Agreement"
        
        view.addSubview(textView)
        view.addSubview(doneButton)
        
        textView.contentInset.left = 12
        textView.contentInset.right = 12
        textView.contentInset.bottom = view.layoutMargins.bottom + 60
        textView.fillSuperview()
        doneButton.anchorCenterXToSuperview()
        doneButton.anchor(bottom: view.layoutMarginsGuide.bottomAnchor, bottomConstant: 16, widthConstant: 150, heightConstant: 44)
    }
    
    // MARK: - User Actions
    
    @objc
    func didTapDone() {
        dismiss(animated: true, completion: nil)
    }

}
