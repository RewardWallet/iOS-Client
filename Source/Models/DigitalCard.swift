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
    
}

extension DigitalCard: PFSubclassing {
    
    static func parseClassName() -> String {
        return "DigitalCard"
    }
}

extension DigitalCard: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
