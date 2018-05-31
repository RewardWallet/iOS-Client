//
//  Review.swift
//  UserClient
//
//  Created by Nathan Tannar on 2/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse

class Review: PFObject {
    
    @NSManaged var user: User?
    @NSManaged var vendor: User?
    @NSManaged var rating: NSNumber?
    @NSManaged var text: String?
}

extension Review: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Review"
    }
}
