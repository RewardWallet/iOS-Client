//
//  DigitalCard.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class DigitalCard: PFObject {
    
    @NSManaged var business: Business?
    @NSManaged var user: User?
    @NSManaged var points: NSNumber?
    
    override init() {
        super.init()
    }
    
    convenience init(business: Business?, user: User?) {
        self.init()
        self.business = business
        self.user = user
        self.points = NSNumber(value: 0)
    }
    
}

extension DigitalCard: PFSubclassing {
    
    static func parseClassName() -> String {
        return "DigitalCard"
    }
}
