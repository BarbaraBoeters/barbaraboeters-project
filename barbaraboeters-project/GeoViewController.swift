//
//  GeoViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 24-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GeoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // 1. setup LocationManager
    let locationManager = CLLocationManager()
    var monitoredRegions: Dictionary<String, Date> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. setup locationManager
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 3. setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. setup test data
        setupData()

    }
    
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Error!",
                                          message: "Location services were previously denied. Please enable location services for this app in Settings.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2. region data
            let title = "SAVED LOCATION"
            let coordinate = CLLocationCoordinate2DMake(52.354699, 4.955915)
            let regionRadius = 10.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            
            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            mapView.addAnnotation(restaurantAnnotation)
            
            // 5. setup circle
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            mapView.add(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    // 6. draw circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }

    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Yay!",
                                      message: "enter \(region.identifier)",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        monitoredRegions[region.identifier] = Date()
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Nay!",
                                      message: "exit \(region.identifier)",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        monitoredRegions.removeValue(forKey: region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegionsWithLocation(locations[0])
    }
    
    // MARK: - Comples business logic
    
    func updateRegionsWithLocation(_ location: CLLocation) {
        
        let regionMaxVisiting = 100.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                //showAlert("Thanks for visiting our restaurant")
                let alert = UIAlertController(title: "Yay!",
                                              message: "Thanks for visiting our restaurant",
                    preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValue(forKey: regionIdentifier)
        }
    }
    

}
