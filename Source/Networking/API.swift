//
//  API.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 1/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse

class API: NSObject {
    
    typealias CompletionBlock = (_ response: Any?, _ error: Error?)->Void
    
    static let shared = API()
    
    // MARK: - Initialization
    
    /// Initialization private, use the static `shared` property
    override private init() { super.init() }
    
    func connectToParseServer() {
        let config = ParseClientConfiguration {
            $0.applicationId = "myAppId"
            $0.clientKey = "myMasterKey"
            $0.server = "http://localhost:1337/parse"
        }
        Parse.initialize(with: config)
    }
    
    // MARK: - Methods [Public]
    
    func testTransaction(block: @escaping CompletionBlock) {
        
        PFCloud.callFunction(inBackground: "testTransaction", withParameters: [:]) { (response, error) in
            block(response, error)
        }
        
    }
    
}
