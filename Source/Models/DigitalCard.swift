//
//  DigitalCard.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse

class DigitalCard: PFObject {
    
    @NSManaged var business: Business?
    @NSManaged var user: User?
    @NSManaged var points: NSNumber?
    
}

extension DigitalCard: PFSubclassing {
    
    static func parseClassName() -> String {
        return "DigitalCard"
    }
}
