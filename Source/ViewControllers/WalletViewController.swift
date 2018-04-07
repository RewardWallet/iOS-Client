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
    
    private var cards: [DigitalCard] = []
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Wallet"
        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage.icon_wallet?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: .icon_wallet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(walletView)
        walletView.fillSuperview(inSafeArea: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDigitalCards()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        walletView.dismissPresentedCardView(animated: animated)
    }
    
    // MARK: - Networks
    
    private func fetchDigitalCards() {
        
        API.shared.fetchDigitalCards { (cards) in
            self.cards = cards
            let cardViews: [DigitalCardView] = cards.map {
                let view = DigitalCardView()
                view.model = $0
                view.delegate = self
                return view
            }
            self.walletView.reload(cardViews: cardViews)
        }
    }
    
    
    // MARK: - User Actions
    
    @objc
    private func addCard() {
        animateSuccess()
    }
    
}

extension WalletViewController: CardViewDelegate {
    
    func cardView(_ cardView: CardView, presentedDidUpdateTo presented: Bool) {
        
        if presented {
            NFCManager.shared.beginReading(callback: { url in
                // TODO: Better handling
                guard url.path.contains("redeem/") else { return }
                API.shared.closeTransaction(transactionId: url.lastPathComponent, inBackground: { (response, error) in
                    print(response)
                    if error == nil {
                        if let digitalCardView = cardView as? DigitalCardView {
                            let newPoints = response?["pointsAdded"] as? Double ?? 0
                            let points: Double = (digitalCardView.model?.points as? Double) ?? 0
                            digitalCardView.model?.points = NSNumber(value: points + newPoints)
                            digitalCardView.subtitleLabel.text = "\(Int(points + newPoints)) Points"
                        }
                        self.animateSuccess()
                    }
                })
            })
        } else {
            NFCManager.shared.endReading()
        }
    }
    
    private func animateSuccess() {
        API.shared.showSuccessHUD(for: 3)
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        emitter.emitterCells = (0..<10).map({ _ in
            let intensity = Float(0.5)
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 6.0 * intensity
            cell.lifetime = 14.0 * intensity
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            let colors: [UIColor] = [UIColor.secondaryColor.darker(), UIColor.secondaryColor.lighter(), UIColor.primaryColor.darker(), UIColor.primaryColor.lighter()]
            let index = Int.random(0, 3)
            cell.contents = colors[index].toImage?.cgImage
            
            return cell
        })
        navigationController?.view.layer.addSublayer(emitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.removeFromSuperlayer()
        }
        walletView.dismissPresentedCardView(animated: true)
    }
    
}
