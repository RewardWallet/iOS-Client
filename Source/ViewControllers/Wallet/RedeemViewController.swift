//
//  RedeemViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 4/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class RedeemViewController: RWViewController {
    
    // MARK: - Properties
    
    private let digitalCard: DigitalCard
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    
    // MARK: - Subviews
    
    private let backgroundImageView = UIImageView(style: Stylesheet.ImageViews.filled) {
        $0.clipsToBounds = true
        $0.backgroundColor = .primaryColor
    }
    
    private let backgroundImageViewOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .offWhite
        return view
    }()
    
    private let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.textColor = .white
        $0.alpha = 0
    }
    
    private let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.textColor = UIColor.white.darker()
        $0.alpha = 0
    }
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let qrCodeView = QRCodeView(style: Stylesheet.Views.farShadowed) {
        $0.layer.cornerRadius = 16
    }
    
    private let nfcScanButton = RippleButton(style: Stylesheet.RippleButtons.primary) {
        $0.apply(Stylesheet.Views.roundedLightlyShadowed)
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setImage(UIImage.iconNFC, for: .normal)
        $0.setTitle("Collect using NFC", for: .normal)
        $0.trackTouchLocation = true
        $0.addTarget(self, action: #selector(RedeemViewController.initiateNFC), for: .touchUpInside)
        $0.alpha = 0
    }
    
    private var timer: Timer?
    
    // MARK: - Initialization
    
    init(for digitalCard: DigitalCard) {
        self.digitalCard = digitalCard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        titleLabel.text = digitalCard.business?.name
        subtitleLabel.text = (digitalCard.points?.doubleValue.roundTwoDecimal() ?? "0") + " Points"
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: digitalCard.business?.image, placeholder: nil, options: [.fromMemoryCacheOrRefresh], progressBlock: nil) { [weak self] (image, _, _, _) in
            if let image = image {
                image.getColors { (colors) in
                    let color = (colors.primary.isLight ? colors.background : colors.primary) ?? .primaryColor
                    self?.nfcScanButton.backgroundColor = color
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.titleLabel.alpha = 1
                        self?.subtitleLabel.alpha = 1
                        self?.nfcScanButton.alpha = 1
                        self?.backgroundImageViewOverlay.backgroundColor = color.withAlphaComponent(0.75)
                    })
                }
            } else {
                self?.nfcScanButton.backgroundColor = .primaryColor
                UIView.animate(withDuration: 0.3, animations: {
                    self?.titleLabel.alpha = 1
                    self?.subtitleLabel.alpha = 1
                    self?.nfcScanButton.alpha = 1
                    self?.backgroundImageViewOverlay.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.75)
                })
            }
        }
        let inset: CGFloat = 10
        qrCodeView.insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        if let businessId = digitalCard.business?.objectId, let userId = digitalCard.user?.objectId {
            qrCodeView.value = businessId + "-" + userId
        }
        
        view.backgroundColor = .offWhite
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(collectionView)
        view.addSubview(qrCodeView)
        view.addSubview(nfcScanButton)
        
        backgroundImageView.addSubview(backgroundImageViewOverlay)
        
        backgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: collectionView.topAnchor, right: view.rightAnchor)
        backgroundImageViewOverlay.fillSuperview()
        
        titleLabel.anchor(nil, left: view.leftAnchor, bottom: backgroundImageView.centerYAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 32)
        subtitleLabel.anchor(backgroundImageView.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 32)
        
        collectionView.anchor(nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 180)
        
        qrCodeView.anchor(view.centerYAnchor, topConstant: 36, widthConstant: 200, heightConstant: 215)
        qrCodeView.anchorCenterXToSuperview()
        
        nfcScanButton.anchorCenterXToSuperview()
        nfcScanButton.anchor(qrCodeView.bottomAnchor, topConstant: 32, widthConstant: 200, heightConstant: 44)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
    }
    
    // MARK: - User Actions
    
    @objc
    func initiateNFC() {
        
        NFCManager.shared.beginReading(callback: { url in
            // TODO: Better handling
            guard url.path.contains("redeem/") else { return }
            API.shared.closeTransaction(transactionId: url.lastPathComponent, inBackground: { [weak self] (response, error) in
                NFCManager.shared.endReading()
                if error == nil {
                    let newPoints = response?["pointsAdded"] as? Double ?? 0
                    let points: Double = (self?.digitalCard.points as? Double) ?? 0
                    self?.digitalCard.points = NSNumber(value: points + newPoints)
                    self?.animateSuccess()
                } else {
                    self?.handleError(error?.localizedDescription)
                }
            })
        })

    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    private func endTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// If they use the QR code still show some confetti
    @objc
    private func handleTimer() {
        
        let currentPoints = digitalCard.points?.doubleValue ?? 0
        digitalCard.fetchInBackground { [weak self] (object, error) in
            guard let updatedCard = object as? DigitalCard else { return }
            let newPoints = updatedCard.points?.doubleValue ?? 0
            if newPoints > currentPoints {
                self?.digitalCard.points = NSNumber(value: newPoints)
                self?.animateSuccess()
            }
        }
    }
    
    // MARK: - Confetti
    
    private func animateSuccess() {
        API.shared.showSuccessHUD(for: 3)
        subtitleLabel.text = (digitalCard.points?.doubleValue.roundTwoDecimal() ?? "0") + " Points"
        
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
        view.layer.addSublayer(emitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.removeFromSuperlayer()
        }
    }
}

extension RedeemViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        return [CouponSectionModel(title: "Coupons", query: API.shared.availableCouponsQuery(for: digitalCard.business!, for: User.current()!))]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CouponListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
