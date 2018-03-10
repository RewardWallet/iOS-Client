//
//  User.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
//    @NSManaged var someValue: String?
 
    override class func current() -> User? {
        return PFUser.current() as? User
    }
    
    /// Saves the object to the server
    ///
    /// - Parameter block: completion block
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        
        super.saveInBackground { success, error in
            block?(success, error)
        }
    }
    
    /// Logs in a user and sets them as the current user
    ///
    /// - Parameters:
    ///   - email: Email Credentials
    ///   - password: Password Credentials
    ///   - completion: A completion block with a result indicating if the login was successful
    class func loginInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {
        
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            completion?(error == nil, error)
            if user != nil {
                PushNotication.shared.registerDeviceInstallation()
            }
        }
        
    }
    
    class func signUpInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {
        
        let user = User()
        user.email = email
        user.username = email
        user.password = password
        user.signUpInBackground { (success, error) in
            completion?(error == nil, error)
            if success {
                PushNotication.shared.registerDeviceInstallation()
            }
        }
    }
    
    class func logoutInBackground(_ completion: ((Bool, Error?) -> Void)?) {
        
        PFUser.logOutInBackground { (error) in
            completion?(error == nil, error)
            PushNotication.shared.unregisterDeviceInstallation()
        }
    }
    
}
