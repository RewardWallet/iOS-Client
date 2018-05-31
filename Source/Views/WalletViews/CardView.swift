//
//  CardView.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 11/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//
//

import UIKit

public protocol CardViewDelegate: class {
    func cardView(_ cardView: CardView, presentedDidUpdateTo presented: Bool)
}

/// The CardView class defines the attributes and behavior of the cards that appear in WalletView objects.
open class CardView: UIView {
    
    // MARK: - Properties [Public]
    
    open weak var delegate: CardViewDelegate?
    
    open var viewController: UIViewController? {
        return walletView?.viewController
    }
    
    /// A Boolean value that determines whether the view is presented.
    open var isPresented: Bool = false { didSet { presentedDidUpdate() } }
    
    /// A parent wallet view object, or nil if the card view is not visible.
    public var walletView: WalletView? {
        var view = superview
        while view != nil {
            if let view = view as? WalletView { return view }
            view = view?.superview
        }
        return nil
    }
    
    // MARK: - Properties [Private]
    
    private(set) public var tapGestureRecognizer        = UITapGestureRecognizer()
    private(set) public var panGestureRecognizer        = UIPanGestureRecognizer()
    private(set) public var forceTouchGestureRecognizer = UIForcePressGestureRecognizer()
    
    // MARK: - Initialization
    
    /// Initializes and returns a newly allocated CardView object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the CardView
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestures()
    }
    
    /// Returns a CardView object initialized from data in a given unarchiver.
    ///
    /// - parameter aDecoder: An unarchiver object.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupGestures()
    }
    
    // MARK: - Methods [Public]
    
    /// Override to set up additional subviews in the CardView
    open func setupViews() {
        
    }
    
    /// Override for any logic when the presentation state changes
    open func presentedDidUpdate() {
        delegate?.cardView(self, presentedDidUpdateTo: isPresented)
    }
    
    /// This method is called when the card view is tapped.
    @objc
    open func tapped() {
        if walletView?.presentedCardView != nil {
            walletView?.dismissPresentedCardView(animated: true)
        } else {
            walletView?.present(cardView: self, animated: true)
        }
    }
    
    /// This method is called when the card view is panned.
    @objc
    open func panned(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            walletView?.grab(cardView: self, popup: false)
        case .changed:
            updateGrabbedCardViewOffset(gestureRecognizer: gestureRecognizer)
        default:
            walletView?.releaseGrabbedCardView()
        }
    }
    
    /// This method is called when the card view is long pressed.
    @objc
    open func longPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            walletView?.grab(cardView: self, popup: true)
        case .changed: ()
        default:
            walletView?.releaseGrabbedCardView()
        }
    }
    
    @objc
    func forcePressed(_ gestureRecognizer: UIForcePressGestureRecognizer) {
        if walletView?.presentedCardView == nil {
            walletView?.present(cardView: self, animated: true)
        }
    }
    
    // MARK: - Methods [Private]
    
    private func setupGestures() {
        
        tapGestureRecognizer.addTarget(self, action: #selector(CardView.tapped))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer.addTarget(self, action: #selector(CardView.panned(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        forceTouchGestureRecognizer.addTarget(self, action: #selector(CardView.longPressed(_:)))
        forceTouchGestureRecognizer.addForceTarget(self, action: #selector(CardView.forcePressed(_:)))
        forceTouchGestureRecognizer.delegate = self
        addGestureRecognizer(forceTouchGestureRecognizer)
    }
    
    private func updateGrabbedCardViewOffset(gestureRecognizer: UIPanGestureRecognizer) {
        let offset = gestureRecognizer.translation(in: walletView).y
        if isPresented && offset > 0 {
            walletView?.updateGrabbedCardView(offset: offset)
        } else if !isPresented {
            walletView?.updateGrabbedCardView(offset: offset)
        }
    }
    
}

extension CardView: UIGestureRecognizerDelegate {
    
    ///  Asks the delegate if a gesture recognizer should begin interpreting touches.
    ///
    ///  - parameter gestureRecognizer: An instance of a subclass of the abstract base class UIGestureRecognizer. This gesture-recognizer object is about to begin processing touches to determine if its gesture is occurring.
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == forceTouchGestureRecognizer && isPresented {
            return false
        } else if gestureRecognizer == panGestureRecognizer && !isPresented && walletView?.grabbedCardView != self {
            return false
        }
        return true
    }
    
    ///  Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
    ///  - parameter gestureRecognizer: An instance of a subclass of the abstract base class UIGestureRecognizer. This gesture-recognizer object is about to begin processing touches to determine if its gesture is occurring.
    ///  - parameter otherGestureRecognizer: An instance of a subclass of the abstract base class UIGestureRecognizer.
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer != tapGestureRecognizer && otherGestureRecognizer != tapGestureRecognizer
    }
}
