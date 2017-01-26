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
import Firebase

typealias getLocationsComplete = (Bool, [Plant]?) -> Void

class GeoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!

    // MARK: Properties
    let ref = FIRDatabase.database().reference(withPath: "plants")
    var plants: [Plant] = []
    let locationManager = CLLocationManager()
    var monitoredRegions: Dictionary<String, Date> = [:]
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        getLocations { (succeed, plants) in
            if succeed {
                for plant in plants! {
                    self.setupData(lat: plant.latitude, long: plant.longitude)
                }
            } else {
                print("No plants found!")
            }
        }
    }
    
    private func getLocations(completion: @escaping getLocationsComplete) {
        var plants = [Plant]()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if let dict = rest.value as? [String: Any] {
                        let plant = Plant(name: dict["name"] as! String, uid: dict["uid"] as! String, completed: dict["completed"] as! Bool, info: dict["info"] as! String, interval: dict["interval"] as! Int, key: rest.key, lastUpdated: dict["lastUpdated"] as! Double, latitude: dict["latitude"] as! Double, longitude: dict["longitude"] as! Double)
                        plants.append(plant)
                        print("PLANTJES = \(plant.latitude) & \(plant.longitude)")
                    }
                }
                DispatchQueue.main.async {
                    completion(true, plants)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        })
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
    
    func setupData(lat: Double, long: Double) {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // 2. region data
            let title = "SAVED LOCATION"
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            let regionRadius = 100.0
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            // 4. setup annotation
            let plantAnnotation = MKPointAnnotation()
            plantAnnotation.coordinate = coordinate;
            plantAnnotation.title = "\(title)";
            mapView.addAnnotation(plantAnnotation)
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
    
    func updateRegionsWithLocation(_ location: CLLocation) {
        let regionMaxVisiting = 100.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                let alert = UIAlertController(title: "Yay!",
                                              message: "Thanks for visiting",
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
