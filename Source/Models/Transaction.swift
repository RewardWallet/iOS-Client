//
//  Transaction.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class Transaction: PFObject {
    
    @NSManaged var text: String?
    @NSManaged var isRedeeming: NSNumber?
    @NSManaged var business: Business?
    
    
}

extension Transaction: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Transaction"
    }
    
}
