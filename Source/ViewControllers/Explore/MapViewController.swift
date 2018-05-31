//
//  RestaurantViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/8/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MapKit
/*
final class MapViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var closeButton = UIButton(style: Stylesheet.Buttons.) {
        $0.addTarget(self,
                     action: #selector(MapViewController.didTapClose),
                     for: .touchUpInside)
    }
    
    private let mapView = MapView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(closeButton)
        mapView.fillSuperview()
        closeButton.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, topConstant: 8, leftConstant: 12, widthConstant: 36, heightConstant: 36)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let location = LocationManager.shared.currentLocation else { return }
        centerMapOnLocation(location, animated: false)
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, animated: Bool) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: animated)
    }
    
    // MARK: - User Actions
    
    @objc
    private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
}
*/
