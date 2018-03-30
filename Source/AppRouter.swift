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
    
    // Auth
    case welcome, login, signup, onboarding, logout
    
    // Explore
    case explore, business
    
    // Wallet
    case wallet
    
    // Notifications
    case notifications
    
    // Account
    case account, profile
    
    // RewardWallet
    case about
    
    var pattern: URLPattern {
        
        let urlScheme = "rewardWallet://rewardwallet.io/"
        
        switch self {
        case .welcome: return urlScheme + "welcome"
        case .login: return urlScheme + "login"
        case .signup: return urlScheme + "signup"
        case .onboarding: return urlScheme + "onboarding"
        case .logout: return urlScheme + "logout"
        case .explore: return urlScheme + "explore"
        case .business : return urlScheme + "business"
        case .wallet: return urlScheme + "wallet"
        case .notifications: return urlScheme + "notifications"
        case .account: return urlScheme + "account"
        case .profile: return urlScheme + "profile"
        case .about: return urlScheme + "about"
        }
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
    
    @discardableResult
    func present(_ route: AppRoute, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        
        if from == nil {
            guard let viewController = viewController(for: route) else { return nil }
            // Switch the windows rootViewController when `from` is nil
            if let wrapClass = wrap {
                let navigationController = wrapClass.init()
                navigationController.pushViewController(viewController, animated: false)
                UIApplication.shared.presentedWindow?
                    .switchRootViewController(viewController,
                                              animated: animated,
                                              duration: 0.5,
                                              options: .transitionFlipFromRight,
                                              completion: { success in
                                                if success {
                                                    completion?()
                                                }
                    })
                return navigationController
            } else {
                UIApplication.shared.presentedWindow?
                    .switchRootViewController(viewController,
                                              animated: animated,
                                              duration: 0.5,
                                              options: .transitionFlipFromRight,
                                              completion: { success in
                                                if success {
                                                    completion?()
                                                }
                    })
                return viewController
            }
        } else {
            return present(route.pattern, context: nil, wrap: wrap, from: from, animated: animated, completion: completion)
        }
        
    }
    
    func push(_ route: AppRoute, context: Any?, from: UINavigationControllerType?, animated: Bool) {
        
        _ = push(route.pattern, context: context, from: from, animated: animated)
    }
    
    // MARK: - Private API
    
    private func registerPaths() {
        
        for route in iterateEnum(AppRoute.self) {
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
            case .logout:
                User.logoutInBackground(nil)
                return self.viewController(for: .welcome)
            case .signup:
                return SignUpViewController()
            case .onboarding:
                return RWViewController() // TODO Add Onboarding
            case .explore, .wallet, .notifications, .account:
                let index = [.explore, .wallet, .notifications, .account].index(of: route)!
                let viewControllers = [ExploreViewController(), WalletViewController(), NotificationsViewController(), AccountViewController()].map {
                        return PrimaryNavigationController(rootViewController: $0)
                }
                let tabBarController = MainContainerController(viewControllers: viewControllers)
                tabBarController.displayViewController(at: index, animated: false)
                return tabBarController
            case .profile:
                return RWViewController()
            case .about:
                return RWViewController()
            case .business:
                return RWViewController()
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
