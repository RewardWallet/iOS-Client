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
import Kingfisher
import UIImageColors

final class Business: PFObject {
    
    @NSManaged var name: String?
    @NSManaged var image: PFFile?
    @NSManaged var address: String?
    @NSManaged var categories: [String]?
    @NSManaged var email: String?
    @NSManaged var about: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var distributionModel: NSNumber?
    
    private var cachedPrimaryColor: UIColor?
    var primaryColor: UIColor {
        if let cachedColor = cachedPrimaryColor {
            return cachedColor
        }
        guard let key = image?.cacheKey else { return .primaryColor }
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: key) else { return .primaryColor }
        let colors = image.getColors()
        cachedPrimaryColor = colors.background.isLight ? colors.primary : colors.background
        return cachedPrimaryColor!
    }

}

extension Business: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Business"
    }
}

