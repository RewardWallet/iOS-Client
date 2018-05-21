//
//  FeaturedSection.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import IGListKit

final class FeaturedSection: NSObject, ListDiffable {
    
    enum SourceType {
        case recommended, recentlyAdded
    }
    
    // MARK: - Properties
    
    let type: SourceType
    
    var title: String {
        switch type {
        case .recommended: return "RECOMMENDED"
        case .recentlyAdded: return "RECENTLY ADDED"
        }
    }
    
    var fetchedBusinesses: [Business]?
    
    init(for type: SourceType) {
        self.type = type
        super.init()
    }
    
    // MARK: - ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
