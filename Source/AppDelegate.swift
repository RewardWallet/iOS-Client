//
//  AppDelegate.swift
//  Reward Wallet
//
//  Created by Nathan Tannar on 11/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import URLNavigator
import AlertHUDKit
import Kingfisher
import AlertHUDKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        API.shared.initialize()
        
        Alert.Defaults.Color.Info = .primaryColor
        Alert.Defaults.Color.Danger = .red
        
        KingfisherManager.shared.defaultOptions = [.fromMemoryCacheOrRefresh]
        
        if let options = launchOptions {
            if let notification = options[.remoteNotification] as? [NSObject : AnyObject] {
                //notification found mean that you app is opened from notification
            }
        }

        
        // Push Notification Access
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { accepted, error in
            guard accepted else {
                print("User declined remote notifications")
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        if User.current() != nil, let exploreVC = AppRouter.shared.viewController(for: .explore) {
            window?.rootViewController = exploreVC
        } else {
            window?.rootViewController = AppRouter.shared.viewController(for: .welcome)
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Try presenting the URL first
        if AppRouter.shared.present(url, wrap: UINavigationController.self) != nil {
            print("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if AppRouter.shared.open(url) == true {
            print("[Navigator] open: \(url)")
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if (error as NSError).code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let data = userInfo["aps"] {
            let notificationMessage = (data as AnyObject).value(forKey: "alert") as? String
            if let message = notificationMessage {
                print("Recieved Remote Notification: \(message)")
                if message.lowercased().contains("thank you for your purchase") {
                    if let view = UIApplication.shared.presentedController?.view {
                        animatedTransactionMessage(view: view)
                    }
                }
                Ping(text: message, style: .info).show()
                UIApplication.shared.applicationIconBadgeNumber += 1
            } else {
                print("Notification was nil")
            }
        } else {
            print("Data was nil")
        }
    }

    func animatedTransactionMessage(view: UIView) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        emitter.emitterCells = (0..<10).map({ _ in
            let intensity = Float(0.5)
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 6.0 * intensity
            cell.lifetime = 14.0 * intensity
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            let colors: [UIColor] = [UIColor.secondaryColor.darker(), UIColor.secondaryColor.lighter(), UIColor.primaryColor.darker(), UIColor.primaryColor.lighter()]
            let index = Int.random(0, 3)
            cell.contents = colors[index].toImage?.cgImage
            
            return cell
        })
        view.layer.addSublayer(emitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.removeFromSuperlayer()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

