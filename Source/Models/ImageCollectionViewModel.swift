//
//  ImageCollectionViewModel.swift
//  Flashh
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import IGListKit
import Parse

final class ImageCollectionViewModel {
    
    let files: [PFFile]
    
    init(files: [PFFile]) {
        self.files = files
    }
    
}

extension ImageCollectionViewModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return files as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let model = object as? ImageCollectionViewModel else { return false }
        return files == model.files
    }
    
}
