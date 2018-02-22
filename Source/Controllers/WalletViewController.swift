//
//  NFCTableViewController.swift
//  RewardWallet
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 2/20/18.
//


import UIKit

class WalletViewController: RWViewController {
    
    // MARK: - Properties
    
    lazy var walletView: WalletView = { [unowned self] in
        let view = WalletView(frame: self.view.frame)
        view.contentInset.top = 20
        view.contentInset.bottom = 60
        view.minimalDistanceBetweenStackedCardViews = 60
        view.preferableCardViewHeight = self.view.frame.height / 3
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wallet"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_wallet?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_wallet)
        
        view.addSubview(walletView)
        walletView.fillSuperview(inSafeArea: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
        
        var cardViews = [DigitalCardView]()
        for _ in 1...10 {
            let card = DigitalCardView()
            cardViews.append(card)
        }
        
        walletView.reload(cardViews: cardViews)
    }
    
    
    // MARK: - User Actions
    
    @objc
    func addCard() {
        walletView.insert(cardView: DigitalCardView(), animated: true, presented: true)
    }
}
