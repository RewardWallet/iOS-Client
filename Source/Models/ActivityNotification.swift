//
//  ActivityNotification.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-13.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class ActivityNotification: PFObject {
    
    @NSManaged var user: User?
    @NSManaged var text: String?
    @NSManaged var referenceObjectId: String?
    @NSManaged var referenceClassName: String?
}

extension ActivityNotification: PFSubclassing {
    
    static func parseClassName() -> String {
        return "ActivityNotification"
    }
}
