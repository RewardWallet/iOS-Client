//
//  LocationManager.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static var shared = LocationManager()
    
    // MARK: - Properties
    
    var currentLocation: CLLocationCoordinate2D? {
        guard let location = location else { return nil }
        return CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        delegate = self
        desiredAccuracy = kCLLocationAccuracyBest // Highest accuracy
        distanceFilter = 10 // Minimum distance device moves in meters to generate an update
        pausesLocationUpdatesAutomatically = true // Automatically pause to save power
    }
    
    // MARK: - Private Functions
    
    /// Begins updating the users location in the background async
    func beginTracking() {
        DispatchQueue.main.async {
            self.requestWhenInUseAuthorization()
            self.startUpdatingLocation()
        }
    }
    
    /// Ends updating the users location in the background async
    func endTracking() {
        DispatchQueue.main.async {
            self.stopUpdatingLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Location services are authorised, track the user.
            beginTracking()
        case .denied, .restricted:
            // Location services not authorised, stop tracking the user.
            endTracking()
        default:
            // Location services pending authorisation.
            // Alert requesting access is visible at this point.
            break
        }
    }
    
    // Get coordinates from address
    func getCoordinates(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            guard error == nil else { return completion(nil) }
            if placemarks?.count != nil {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                completion(coordinate)
            } else {
                completion(nil)
            }
        })
    }
    
}
