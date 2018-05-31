//
//  LocationCell.swift
//  Shared
//
//  Created by Nathan Tannar on 1/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MapKit
import IGListKit
import CoreLocation

class LocationCell: RWCollectionViewCell {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = { [weak self] in
        let mapView = MKMapView()
        mapView.isScrollEnabled = false
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        return mapView
    }()
    
    // MARK: - Methods [Public]
    
    override func setupView() {
        super.setupView()
        contentView.addSubview(mapView)
        contentView.apply(Stylesheet.Views.roundedLightlyShadowed)
        mapView.fillSuperview()
    }
    
    // MARK: - Methods [Private]
    
    func plotOnMap(address: String) {
        
        guard mapView.annotations.isEmpty else { return }
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            
            guard let coordinate = placemarks?.first?.location?.coordinate else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = address
                
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.centerMapTo(coordinate: coordinate)
            }
        })
    }
    
    func centerMapTo(coordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
}

extension LocationCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let location = viewModel as? String else { return }
        plotOnMap(address: location)
    }
}

extension LocationCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let identifier = "pin"
        if #available(iOS 11.0, *) {
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedAnnotationView.annotation = annotation
                dequeuedAnnotationView.canShowCallout = true
                return dequeuedAnnotationView
            }
            else {
                let av = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                av.tintColor = .tertiaryColor
                av.canShowCallout = true
                return av
            }
        } else {
            // Fallback on earlier versions
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedAnnotationView.annotation = annotation
                dequeuedAnnotationView.canShowCallout = true
                return dequeuedAnnotationView
            }
            else {
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                av.tintColor = .tertiaryColor
                av.canShowCallout = true
                return av
            }
        }
    }
}
