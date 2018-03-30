//
//  DigitalCardView.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import UIImageColors

class DigitalCardView: CardView {
    
    // MARK: - Properties [Public]
    
    weak var model: DigitalCard? { didSet { syncViewWithModel() } }
    
    let titleLabel = UILabel(style: Stylesheet.Labels.header)
    
    let subtitleLabel = UILabel(style: Stylesheet.Labels.subheader)
    
    let logoImageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare)
    
    let gradientView = GradientView()
    
    // MARK: - Properties [Private]
    
    private var logoImageViewConstraints: [NSLayoutConstraint]?
    
    // MARK: - View Setup
    
    override func setupViews() {
        super.setupViews()
        
        layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        addSubview(gradientView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(logoImageView)
        
        gradientView.layer.cornerRadius = 10
        gradientView.clipsToBounds = true
        gradientView.fillSuperview()
        
        let inset: CGFloat = 10
        logoImageViewConstraints = logoImageView.anchor(topAnchor, left: leftAnchor, topConstant: inset, leftConstant: inset, widthConstant: 40, heightConstant: 40)
        titleLabel.anchor(logoImageView.topAnchor, left: logoImageView.rightAnchor, bottom: subtitleLabel.topAnchor, right: rightAnchor, leftConstant: inset, rightConstant: inset)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor)
        
        // Fake Data
        titleLabel.text = Lorem.words().capitalized
        subtitleLabel.text = "\(Randoms.randomInt(100, 4000)) Points"
        
        let images: [UIImage] = [#imageLiteral(resourceName: "Starbucks"), #imageLiteral(resourceName: "Boston Pizza"), #imageLiteral(resourceName: "TimHortons")]
        let image = images[Randoms.randomInt(0, images.count - 1)]
        logoImageView.image = image
        
        image.getColors { [weak self] (colors) in
            self?.gradientView.colors = [colors.background, colors.background.darker()]
            self?.titleLabel.textColor = colors.primary
            self?.subtitleLabel.textColor = colors.secondary
        }
    }
    
    private func syncViewWithModel() {
        
    }
    
    override func presentedDidUpdate() {
        
        let duration: TimeInterval = 0.3
        
        UIView.animate(withDuration: duration, animations: {
            let constant: CGFloat = self.presented ? 80 : 40
            self.logoImageViewConstraints?
                .filter { $0.identifier == "height" || $0.identifier == "width" }
                .forEach { $0.constant = constant }
            self.layoutIfNeeded()
        })
        
    }
    
    // MARK: - User Actions
    
    @objc
    func deleteCard() {
        walletView?.remove(cardView: self, animated: true, completion: nil)
    }
    
    
}


