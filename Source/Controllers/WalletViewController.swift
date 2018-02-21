//
//  NFCTableViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 1/22/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class WalletViewController: RWViewController {
    
    // MARK: - Properties
    
    lazy var walletView = WalletView(frame: self.view.frame)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white
        view.addSubview(walletView)
        walletView.fillSuperview()
        walletView.contentInset.top = 40
        
        title = "Wallet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
        
        var coloredCardViews = [CardView]()
        for index in 1...2 {
            let card = MockCard()
            card.index = index
            coloredCardViews.append(card)
        }
        
        walletView.reload(cardViews: coloredCardViews)
    }
    
    
    // MARK: - User Actions
    
    @objc
    func addCard() {
        walletView.insert(cardView: MockCard(), animated: true, presented: true)
    }
}

class MockCard: QRCardView {
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var index: Int = 0 {
        didSet {
            label.text = "#\(index)"
        }
    }

    override func presentedDidUpdate() {
//        UIView.animate(withDuration: 0.3) {
//            self.backgroundColor = self.presented ? UIColor.red : .white
//        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        qrCodeView.value = "2bd792iasfF"
        
        layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundColor = .red
        
        addSubview(label)
        label.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)

    }
    
    @objc
    func deleteCard() {
        walletView?.remove(cardView: self, animated: true, completion: nil)
    }
}

