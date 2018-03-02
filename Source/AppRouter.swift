//
//  AppRouter.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/5/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import URLNavigator
import SafariServices
import DynamicTabBarController

enum AppRoute {
    
    case welcome, login, signup, wallet, main
    
    var pattern: URLPattern {
        
        let urlScheme = "rewardWallet://"
        
        switch self {
        case .welcome: return urlScheme + "welcome"
        case .login: return urlScheme + "login"
        case .signup: return urlScheme + "signup"
        case .wallet: return urlScheme + "wallet"
        case .main: return urlScheme + "main"
        }
    }
    
    static func all() -> [AppRoute] {
        return [.welcome, .login, .signup, .wallet, .main]
    }
}

class AppRouter: Navigator {
    
    static var shared = AppRouter()
    
    /// Initialization private, use the static `shared` property
    private override init() {
        super.init()
        delegate = self
        registerPaths()
    }
    
    // MARK: - Public API
    
    func viewController(for route: AppRoute) -> UIViewController? {
        return viewController(for: route.pattern)
    }
    
    func present(_ route: AppRoute, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) {
        
        if from == nil, let viewController = viewController(for: route) {
            // Switch the windows rootViewController when `from` is nil
            UIApplication.shared.presentedWindow?.switchRootViewController(viewController, animated: animated, duration: 0.5, options: .transitionFlipFromRight, completion: completion)
        } else {
            present(route.pattern, context: nil, wrap: wrap, from: from, animated: animated, completion: completion)
        }
        
    }
    
    // MARK: - Private API
    
    private func registerPaths() {
        
        for route in AppRoute.all() {
            register(route.pattern, viewControllerFactory(for: route))
        }
        
        //        register("navigator://user/<username>") { url, values, context in
        //            guard let username = values["username"] as? String else { return nil }
        //            return UserViewController(navigator: navigator, username: username)
        //        }
        //        register("http://<path:_>", self.webViewControllerFactory)
        //        register("https://<path:_>", self.webViewControllerFactory)
        //
        //        handle("navigator://alert", self.alert(navigator: navigator))
        //        handle("navigator://<path:_>") { (url, values, context) -> Bool in
        //            // No navigator match, do analytics or fallback function here
        //            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
        //            return true
        //        }
    }
    
    private func viewControllerFactory(for route: AppRoute) -> ViewControllerFactory {
        return { (url, values, context) -> UIViewController? in
            // Code
            switch route {
            case .welcome:
                return WelcomeViewController()
            case .login:
                return LoginViewController()
            case .signup:
                return SignUpViewController()
            case .main:
                let tabBarController = MainContainerController(viewControllers: [
                    HomeViewController(),
                    WalletViewController(),
                    NotificationsViewController(),
                    NFCTableViewController(),
                ])
                return RWNavigationController(rootViewController: tabBarController)
            default:
                print("[ViewControllerFactory failed for route: \(route)")
                return nil
            }
        }
    }
    
    private func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController)
            return true
        }
    }

}

extension AppRouter: NavigatorDelegate {
    
    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool {
        return true
    }
    
    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool {
        return true
    }
    
}
