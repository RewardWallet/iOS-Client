//
//  Business.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import IGListKit

class Business: PFObject {
    
    @NSManaged var username: String?
    @NSManaged var name: String?
    @NSManaged var image: PFFile?
    @NSManaged var address: String?
    @NSManaged var category: String?
    @NSManaged var email: String?
    @NSManaged var distributionModel: NSNumber?
    
}

extension Business: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Business"
    }
}

extension Business: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
