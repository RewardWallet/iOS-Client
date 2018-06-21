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
    
    case dispatch
    
    // Auth
    case welcome, login, signup, onboarding, logout
    
    // Explore
    case explore, business
    
    // Wallet
    case wallet, redeem, addToWallet
    
    // Notifications
    case notifications
    
    // Account
    case account, profile
    
    // RewardWallet
    case about, termsOfService
    
    var pattern: URLPattern {
        
        let urlScheme = "rewardWallet://rewardwallet.io/"
        
        switch self {
        case .dispatch: return urlScheme
        case .welcome: return urlScheme + "welcome/"
        case .onboarding: return urlScheme + "welcome/onboarding/"
        case .login: return urlScheme + "login/"
        case .signup: return urlScheme + "signup/"
        case .logout: return urlScheme + "logout/"
        case .explore: return urlScheme + "explore/"
        case .business : return urlScheme + "business/"
        case .wallet: return urlScheme + "wallet/"
        case .addToWallet: return urlScheme + "wallet/add/"
        case .redeem: return urlScheme + "wallet/redeem/"
        case .notifications: return urlScheme + "notifications/"
        case .account: return urlScheme + "account/"
        case .profile: return urlScheme + "profile/"
        case .about: return urlScheme + "about/"
        case .termsOfService: return urlScheme + "about/terms-and-service"
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
    
    func viewController(for route: AppRoute, context: Any? = nil) -> UIViewController? {
        return viewController(for: route.pattern, context: context)
    }
    
    @discardableResult
    func present(_ route: AppRoute, context: Any? = nil, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        
        if from == nil {
            guard let viewController = viewController(for: route, context: context) else { return nil }
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
            return present(route.pattern, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
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
            case .dispatch:
                return DispatchViewController()
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
                let historyTBVC = HistoryTabBarController(viewControllers: [TransactionsViewController(), NotificationsViewController()])
                let viewControllers = [ExploreViewController(), WalletViewController(), historyTBVC, AccountViewController()].map {
                        return PrimaryNavigationController(rootViewController: $0)
                }
                let tabBarController = MainContainerController(viewControllers: viewControllers)
                tabBarController.displayViewController(at: index, animated: false)
                return tabBarController
            case .profile:
                guard let user = User.current() else { return self.viewController(for: .login) }
                return EditProfileViewController(user: user)
            case .business:
                guard let business = context as? Business else { fatalError("Business nil in context") }
                return BusinessViewController(for: business)
            case .addToWallet:
                guard let business = context as? Business else { fatalError("Business nil in context") }
                return AddToWalletViewController(for: business)
            case .redeem:
                guard let digitalCard = context as? DigitalCard else { fatalError("DigitalCard nil in context") }
                return RedeemViewController(for: digitalCard)
            case .about:
                return RWViewController()
            case .termsOfService:
                return TermsOfServiceViewController()
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
