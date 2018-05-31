//
//  Checkbox.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/27/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import M13Checkbox

class Checkbox: M13Checkbox {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupControl() {
        boxType = .circle
        tintColor = .primaryColor
        secondaryTintColor = .grayColor
        animationDuration = 0.15
        checkmarkLineWidth = 1.5
        boxLineWidth = 2

    }
    
}
