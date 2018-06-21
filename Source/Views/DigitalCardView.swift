//
//  DigitalCardView.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import UIImageColors
import DeckTransition

class DigitalCardView: CardView {
    
    // MARK: - Properties
    
    weak var digitalCard: DigitalCard? { didSet { updateViewForDigitalCard() } }
    
    private var logoImageViewConstraints: [NSLayoutConstraint]?
    
    // MARK: - Subviews
    
    private let titleLabel = UILabel(style: Stylesheet.Labels.header)
    
    private let subtitleLabel = UILabel(style: Stylesheet.Labels.subheader)
    
    private let logoImageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare)
    
    private let gradientView = GradientView()
    
    private let scanButton = UIButton(style: Stylesheet.Buttons.roundedWhite) {
        $0.setTitle("Scan", for: .normal)
//        $0.setImage(UIImage.iconCollect, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 2
        $0.alpha = 0
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(DigitalCardView.viewCardDetails), for: .touchUpInside)
    }
    
    private let detailButton = UIButton(style: Stylesheet.Buttons.roundedWhite) {
        $0.setTitle("Details", for: .normal)
//        $0.setImage(UIImage.iconBusinessDetails, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 2
        $0.alpha = 0
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(DigitalCardView.viewBusinessDetails), for: .touchUpInside)
    }
    
    // MARK: - View Setup
    
    override func setupViews() {
        super.setupViews()
        
        alpha = 0
        layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        addSubview(gradientView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(logoImageView)
        
        let stackView = UIStackView(arrangedSubviews: [scanButton, detailButton])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 36
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        titleLabel.textColor = .white
        subtitleLabel.textColor = UIColor.white.darker()
        gradientView.colors = [.primaryColor, UIColor.primaryColor.darker()]
        gradientView.layer.cornerRadius = 10
        gradientView.clipsToBounds = true
        gradientView.fillSuperview()
        
        let inset: CGFloat = 10
        logoImageViewConstraints = logoImageView.anchor(topAnchor, left: leftAnchor, topConstant: inset, leftConstant: inset, widthConstant: 40, heightConstant: 40)
        titleLabel.anchor(logoImageView.topAnchor, left: logoImageView.rightAnchor, bottom: subtitleLabel.topAnchor, right: rightAnchor, leftConstant: inset, rightConstant: inset)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor)
        
        stackView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 44)
    }
    
    private func updateViewForDigitalCard() {
        titleLabel.text = digitalCard?.business?.name
        subtitleLabel.text = (digitalCard?.points?.doubleValue.roundTwoDecimal() ?? "0") + " Points"
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: digitalCard?.business?.image, placeholder: nil, options: [.fromMemoryCacheOrRefresh], progressBlock: nil) { [weak self] (image, _, _, _) in
            if let image = image {
                let colors = image.getColors()
                let top = (colors.primary.isLight ? colors.background : colors.primary) ?? .primaryColor
                let bottom = top.darker()
                self?.gradientView.colors = [top, bottom]
            }
            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 1
            })
        }
    }
    
    override func presentedDidUpdate() {
        super.presentedDidUpdate()
        
        let duration: TimeInterval = 0.3
        UIView.animate(withDuration: duration, animations: {
            let constant: CGFloat = self.isPresented ? 80 : 40
            self.detailButton.alpha = self.isPresented ? 1 : 0
            self.scanButton.alpha = self.isPresented ? 1 : 0
            self.logoImageViewConstraints?
                .filter { $0.identifier == "height" || $0.identifier == "width" }
                .forEach { $0.constant = constant }
            self.layoutIfNeeded()
        })
        
    }
    
    // MARK: - User Actions
    
    @objc
    private func deleteCard() {
        walletView?.remove(cardView: self, animated: true, completion: nil)
    }
    
    @objc
    private func viewCardDetails() {
        let transitionDelegate = DeckTransitioningDelegate()
        guard let detailViewController = AppRouter.shared.viewController(for: .redeem, context: digitalCard) else { return }
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = transitionDelegate
        AppRouter.shared.present(detailViewController, from: viewController, animated: true, completion: nil)
    }
    
    @objc
    private func viewBusinessDetails() {
        AppRouter.shared.push(.business, context: digitalCard?.business, from: viewController?.navigationController, animated: true)
    }
    
    
}


