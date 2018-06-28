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
    
    // Shared Singleton
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
        SVProgressHUD.setMinimumSize(CGSize(width: 75, height: 75))
        SVProgressHUD.setBackgroundColor(UIColor(r: 250, g: 250, b: 250))
    }
    
    func initialize() {
        
        [User.self, Transaction.self, Business.self, DigitalCard.self, ActivityNotification.self, RewardModel.self].forEach { $0.registerSubclass() }
        Parse.setLogLevel(.debug)
        Parse.enableLocalDatastore()
        let config = ParseClientConfiguration {
            $0.applicationId = "5ejBLYkzVaVibHAIIQZvbawrEywUCNqpDFVpHgU"
            $0.clientKey = "oR3Jp5YMyxSBu6r6nh9xuYQD5AcsdubQmvATY1OEtXo"
            $0.server = "https://nathantannar.me/api/prod/"
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
    
    func showSuccessHUD(for duration: TimeInterval = 1) {
        SVProgressHUD.showSuccess(withStatus: "Success")
        SVProgressHUD.dismiss(withDelay: duration)
    }
    
    func fetchRecommendedBusinesses(inBackground completion: @escaping ([Business])->Void) {
        
        guard let query = Business.query() as? PFQuery<Business> else { fatalError() }
        query.includeKey("rewardModel")
        query.addDescendingOrder("updatedAt")
        query.findObjectsInBackground { (objects, error) in
            guard let businesses = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(businesses)
        }
    }
    
    func fetchRecentBusinesses(inBackground completion: @escaping ([Business])->Void) {
        
        guard let query = Business.query() as? PFQuery<Business> else { fatalError() }
        query.includeKey("rewardModel")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
            guard let businesses = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(businesses)
        }
    }
    
    func fetchBusinesses(filtered filter: String, completion: @escaping ([Business])->Void) {
        
        var queries = [PFQuery<PFObject>]()
        
        guard let nameQuery = Business.query() else { fatalError() }
        nameQuery.whereKey("name", contains: filter)
        queries.append(nameQuery)
        
        guard let addressQuery = Business.query() else { fatalError() }
        addressQuery.whereKey("address", contains: filter)
        queries.append(addressQuery)
        
        guard let categoryQuery = Business.query() else { fatalError() }
        categoryQuery.whereKey("categories", contains: filter)
        queries.append(categoryQuery)
        
        let query = PFQuery.orQuery(withSubqueries: queries)
        query.includeKey("rewardModel")
        query.limit = 10
        query.findObjectsInBackground { (objects, error) in
            guard let businesses = objects as? [Business], error == nil else {
                print(error ?? "Error")
                return
            }
            completion(businesses)
        }
    }
    
    func fetchTransactions(inBackground completion: @escaping ([Transaction])->Void) {
        
        guard let user = User.current(), let query = Transaction.query() as? PFQuery<Transaction> else { fatalError() }
        query.whereKey("user", equalTo: user)
        query.addDescendingOrder("updatedAt")
        query.includeKeys(["business"])
        query.findObjectsInBackground { (objects, error) in
            guard let transactions = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(transactions)
        }
    }
    
    func fetchDigitalCards(inBackground completion: @escaping ([DigitalCard])->Void) {
        
        guard let user = User.current(), let query = DigitalCard.query() as? PFQuery<DigitalCard> else { fatalError() }
        query.whereKey("user", equalTo: user)
        query.includeKeys(["business"])
        query.findObjectsInBackground { (objects, error) in
            guard let digitalCards = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(digitalCards)
        }
    }
    
    func fetchNotifications(inBackground completion: @escaping ([ActivityNotification])->Void) {
        
        guard let user = User.current(), let query = ActivityNotification.query() as? PFQuery<ActivityNotification> else { fatalError() }
        query.whereKey("user", equalTo: user)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
            guard let notifications = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(notifications)
        }
    }
    
    func closeTransaction(transactionId: String, inBackground block: (([String:Any]?, Error?)->Void)?) {

        guard let userId = User.current()?.objectId else { return }
        let params: [AnyHashable: Any] = ["transactionId": transactionId, "userId": userId]
        PFCloud.callFunction(inBackground: "closeTransaction", withParameters: params) { (response, error) in
            block?(response as? [String:Any], error)
        }
        
    }
    
    func fetchDigitalCard(for business: Business, completion: @escaping (DigitalCard?)->Void) {
        
        guard let user = User.current(), let query = DigitalCard.query() as? PFQuery<DigitalCard> else { fatalError() }
        query.whereKey("user", equalTo: user)
        query.whereKey("business", equalTo: business)
        query.includeKeys(["business"])
        query.getFirstObjectInBackground { (digitalCard, error) in
            completion(digitalCard)
        }
    }
    
    func availableCouponsQuery(for business: Business, for user: User) -> PFQuery<Coupon> {
        
//        let privateCouponQuery = user.availableCoupons.query()
        let publicCouponQuery = Coupon.query() as! PFQuery<Coupon>
        publicCouponQuery.whereKey("isPublic", equalTo: true)
        publicCouponQuery.whereKey("business", equalTo: business)
        return publicCouponQuery
        
//        let query = PFQuery.orQuery(withSubqueries: [privateCouponQuery, publicCouponQuery] as! [PFQuery<PFObject>])
//        query.whereKey("expireDate", greaterThan: Date())
//        return query as! PFQuery<Coupon>
    }
    
}
