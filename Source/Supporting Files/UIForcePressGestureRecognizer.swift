//
//  UIForcePressGestureRecognizer.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 11/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//
//  Adapted rom https://stackoverflow.com/questions/32771947/3d-touch-force-touch-implementation
//

import AudioToolbox
import UIKit.UIGestureRecognizerSubclass

/// A UIGestureRecognizer that fires a selelector on 3D Touch.
open class UIForcePressGestureRecognizer: UIGestureRecognizer {
    
    // MARK: - Properties [Public]
    
    open var vibrateOnForcePress = true
    open var threshold: CGFloat = 0.5
    open var forceTriggerMinTime: TimeInterval = 2
    
    private(set) public var forceAction: Selector? = nil
    private(set) public var target: Any? = nil
    
    // MARK: - Properties [Private]
    
    private var forcePressed: Bool = false
    private var forcePressedAt: TimeInterval = 0
    private var kPeakSoundID:UInt32 = 1519
    
    // MARK: - Initialization
    
    public init() {
        super.init(target: nil, action: nil)
    }
    
    public required init(target: Any?, action: Selector, forceAction: Selector? = nil) {
        self.target = target
        self.forceAction = forceAction
        super.init(target: target, action: action)
    }
    
    public func addForceTarget(_ target: Any?, action: Selector?) {
        self.target = target
        self.forceAction = action
    }
    
    // MARK: - Methods [Public]
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = forcePressed ? .ended : .failed
        forcePressed = false
    }
    
    // MARK: - Methods [Private]
    
    private func handleTouch(_ touch: UITouch) {
        
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
        
        let forcePercentage = (touch.force / touch.maximumPossibleForce)
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        if !forcePressed && forcePercentage >= threshold && forcePercentage < 1 {
            state = .began
            if vibrateOnForcePress {
                AudioServicesPlaySystemSound(kPeakSoundID)
            }
            forcePressedAt = NSDate.timeIntervalSinceReferenceDate
            forcePressed = true
            
        } else if forcePressed && forcePercentage <= 0 {
            state = .ended
            forcePressed = false
            return
        }
        if (forcePressed && (currentTime - forcePressedAt) > forceTriggerMinTime) || forcePercentage >= 1 {
            state = .ended
            forcePressed = false
            
            if vibrateOnForcePress {
                AudioServicesPlaySystemSound(kPeakSoundID)
            }
            
            //fire force press
            if let forceAction = self.forceAction, let target = self.target {
                _ = (target as AnyObject).perform(forceAction, with: self)
            }
        }
    }
}
