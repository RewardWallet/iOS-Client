/*
 MIT License
 
 Copyright © 2017 Nathan Tannar.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import Parse

class PushNotication: NSObject {
    
    // MARK: - Properties
    
    static let shared = PushNotication()
    
    // MARK: - Initialization
    
    /// Initialization private, use the static `shared` property
    override private init() { super.init() }
    
    // MARK: - Public API
    
    func registerDeviceInstallation() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let installation = PFInstallation.current() else { return }
        installation["user"] = PFUser.current()
        installation.saveInBackground(block: { (success, error) in
            if error != nil {
                print("parsePushUserAssign save error.")
            }
        })
    }
    
    func unregisterDeviceInstallation() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let installation = PFInstallation.current() else { return }
        installation.remove(forKey: "user")
        installation.saveInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print("parsePushUserResign save error")
            }
        }
    }
    
//    class func send(to user: User, message: String) {
//
//        PFCloud.callFunction(inBackground: "pushToUser",
//                             withParameters: ["user": user.objectId!, "message": message],
//                             block: { (object, error) in
//            if error == nil {
//                print("##### PUSH OK")
//            } else {
//                print("##### ERROR: \(error.debugDescription)")
//            }
//        })
//    }
    
}
