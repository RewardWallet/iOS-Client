//
//  Transaction.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse

class Transaction: PFObject {
    
    //    @NSManaged var someValue: String?
    
}

extension Transaction: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Transaction"
    }
}
