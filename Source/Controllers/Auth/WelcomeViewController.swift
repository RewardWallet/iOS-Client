//
//  WelcomeViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

fileprivate let kInitialAnchorConstant: CGFloat = -30
fileprivate let kFinalAnchorConstant: CGFloat = 200

class WelcomeViewController: RWViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.text = "RewardWallet"
    }
    
    let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.text = "A reward program for small businesses"
    }
    
    let logoImageView = UIImageView(style: Stylesheet.ImageView.fitted) {
        $0.image = .coin
    }
    
    lazy var loginButton = UIButton(style: Stylesheet.Buttons.roundedWhite) {
        $0.setTitle("Login", for: .normal)
        $0.addTarget(self,
                         action: #selector(WelcomeViewController.didTapLogin),
                         for: .touchUpInside)
    }
    
    lazy var signUpButton: UIButton = { [weak self] in
        let button = UIButton()
        let normalTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: .white).bold("Sign up here", size: 14, color: .white)
        let highlightedTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: UIColor.white.withAlphaComponent(0.3)).bold("Sign up here", size: 14, color: UIColor.white.withAlphaComponent(0.3))
        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        button.addTarget(self,
                         action: #selector(WelcomeViewController.didTapSignUp),
                         for: .touchUpInside)
        return button
    }()
    
    let backgroundView: UIView = {
        class ContentView: UIView {
            // Draws a rectangle with a triangular inset at the top mid x
            override func draw(_ rect: CGRect) {
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.beginPath()
                let scale = -kInitialAnchorConstant
                context.move(to: CGPoint(x: rect.minX, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.midX - scale, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.midX, y: rect.minY + scale))
                context.addLine(to: CGPoint(x: rect.midX + scale, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                context.addLine(to: CGPoint(x: rect.minY, y: rect.maxY))
                context.closePath()
                context.setFillColor(UIColor.primaryColor.cgColor)
                context.fillPath()
            }
        }
        let view = ContentView()
        let gradientView = GradientView()
        gradientView.colors = [.primaryColor, .secondaryColor]
        view.addSubview(gradientView)
        gradientView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50)
        view.backgroundColor = .white
        return view
    }()
    
    private var backgroundViewTopAnchor: NSLayoutConstraint?
    private var hasAnimatedFirstLaunch: Bool = false
    private var hasAnimatedLaunch: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(backgroundView)
        backgroundView.addSubview(logoImageView)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(signUpButton)
        
        backgroundViewTopAnchor = backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: kInitialAnchorConstant).first
        
        titleLabel.anchor(left: view.layoutMarginsGuide.leftAnchor, bottom: subtitleLabel.topAnchor, right: view.layoutMarginsGuide.rightAnchor, leftConstant: 24, bottomConstant: 10, rightConstant: 24, heightConstant: 40)
        subtitleLabel.anchor(left: titleLabel.leftAnchor, bottom: backgroundView.topAnchor, right: titleLabel.rightAnchor, bottomConstant: 40, heightConstant: 20)
        
        logoImageView.anchorCenterXToSuperview()
        logoImageView.anchor(backgroundView.topAnchor, topConstant: 50, widthConstant: 150, heightConstant: 150)
        
        loginButton.anchorCenterXToSuperview()
        loginButton.anchor(bottom: signUpButton.topAnchor, bottomConstant: 10, widthConstant: 200, heightConstant: 44)
        
        signUpButton.anchorCenterXToSuperview()
        signUpButton.anchor(bottom: backgroundView.bottomAnchor, bottomConstant: 40, heightConstant: 20)
        
        // Prep Animation
        logoImageView.alpha = hasAnimatedLaunch ? 1 : 0
        loginButton.alpha = hasAnimatedLaunch ? 1 : 0
        signUpButton.alpha = hasAnimatedLaunch ? 1 : 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate Launch
        guard !hasAnimatedLaunch else { return }
        maximizeBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Animate Launch
        guard !hasAnimatedLaunch, hasAnimatedFirstLaunch else { return }
        maximizeBackgroundView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unanimate Launch
        guard hasAnimatedLaunch else { return }
        minimizeBackgroundView()
    }
    
    // MARK: - Animations
    
    private func maximizeBackgroundView() {
        UIView.animate(withDuration: 1, delay: 0.3, options: [], animations: {
            // Alpha animation shouldn't be done in a spring animation
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1
            self.logoImageView.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.backgroundViewTopAnchor?.constant = kFinalAnchorConstant
            self.view.layoutIfNeeded()
        }) { success in
            self.hasAnimatedLaunch = success
            self.hasAnimatedFirstLaunch = success
            self.beginCoinAnimation()
        }
    }
    
    private func minimizeBackgroundView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            // Alpha animation shouldn't be done in a spring animation
            self.loginButton.alpha = 0
            self.signUpButton.alpha = 0
            self.logoImageView.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.backgroundViewTopAnchor?.constant = kInitialAnchorConstant
            self.view.layoutIfNeeded()
        }) { success in
            self.hasAnimatedLaunch = !success
        }
    }
    
    private func beginCoinAnimation() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = "flip"
        transition.subtype = "fromRight"
        transition.duration = 2
        transition.repeatCount = .infinity
        logoImageView.layer.add(transition, forKey: "flipFromRight")
    }
    
    // MARK: - User Actions
    
    
    @objc
    func didTapLogin() {
        
        let navigationController = RWNavigationController(rootViewController: LoginViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func didTapSignUp() {
        
        
        
//        let emitter = CAEmitterLayer()
//        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2.0, y: 0)
//        emitter.emitterShape = kCAEmitterLayerLine
//        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
//        emitter.emitterCells = (0..<5).map({ _ in
//            let intensity = Float(0.5)
//
//            let cell = CAEmitterCell()
//
//            cell.birthRate = 6.0 * intensity
//            cell.lifetime = 14.0 * intensity
//            cell.lifetimeRange = 0
//            cell.velocity = CGFloat(350.0 * intensity)
//            cell.velocityRange = CGFloat(80.0 * intensity)
//            cell.emissionLongitude = .pi
//            cell.emissionRange = .pi / 4
//            cell.spin = CGFloat(3.5 * intensity)
//            cell.spinRange = CGFloat(4.0 * intensity)
//            cell.scaleRange = CGFloat(intensity)
//            cell.scaleSpeed = CGFloat(-0.1 * intensity)
//            cell.contents = UIColor.red.toImage?.cgImage
//
//            return cell
//        })
//        view.layer.addSublayer(emitter)
    }
    
}
