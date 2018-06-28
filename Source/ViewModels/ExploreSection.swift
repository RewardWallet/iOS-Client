//
//  FeaturedSection.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import IGListKit

final class FeaturedSection: ListDiffable {
    
    enum SourceType {
        case recommended, recentlyAdded
    }
    
    // MARK: - Properties
    
    var title: String {
        switch type {
        case .recommended: return "RECOMMENDED"
        case .recentlyAdded: return "RECENTLY ADDED"
        }
    }
    
    var fetchedBusinesses: [Business]?
    
    let type: SourceType
    
    private let uuid: String
    
    init(for type: SourceType) {
        self.type = type
        self.uuid = UUID().uuidString
    }
    
    // MARK: - ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return uuid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let section = object as? FeaturedSection else { return false }
        return uuid == section.uuid
    }
    
}
