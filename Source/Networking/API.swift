//
//  API.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 1/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import SVProgressHUD

class API: NSObject {
    
    typealias CompletionBlock = (_ response: Any?, _ error: Error?)->Void
    
    static let shared = API()
    
    private var isIgnoreingUserInteraction: Bool {
        return UIApplication.shared.isIgnoringInteractionEvents
    }
    
    // MARK: - Initialization
    
    /// Initialization private, use the static `shared` property
    override private init() {
        super.init()
        SVProgressHUD.setHapticsEnabled(true)
        SVProgressHUD.setRingRadius(30)
        SVProgressHUD.setBackgroundColor(UIColor(r: 250, g: 250, b: 250))
    }
    
    func initialize() {
        let config = ParseClientConfiguration {
            $0.applicationId = "bgLNDAw0XZhLF1lWYdll8pByveBqh9IBtTMJZOqa"
            $0.clientKey = "FZnarnKjQxFYDNKryh3IV4O0m2mNhxIM73hP6b3f"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: config)
    }
    
    // MARK: - Methods [Public]
    
    func showProgressHUD(ignoreUserInteraction: Bool) {
        SVProgressHUD.show()
        if ignoreUserInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func dismissProgressHUD() {
        SVProgressHUD.dismiss()
        if isIgnoreingUserInteraction {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func testTransaction(block: @escaping CompletionBlock) {
        
        PFCloud.callFunction(inBackground: "testTransaction", withParameters: [:]) { (response, error) in
            block(response, error)
        }
        
    }
    
}
