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
    let currentUser = FIRDatabase.database().reference(withPath: "users").child((FIRAuth.auth()?.currentUser)!.uid)
    var currentU = ""
    
    var plants: [Plant] = []
    var waterPlants: [Plant] = []
    
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
                    self.setupData(lat: plant.latitude, long: plant.longitude, name: plant.name)
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
                        
                        self.currentU = (FIRAuth.auth()!.currentUser?.uid)!
                        
                        let plantUid = plant.uid
                        
                        if plantUid == self.currentU {
                            plants.append(plant)
                        }
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
        // Authorization code
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Error!",
                                          message: "Location services were previously denied. Please enable location services for this app in Settings.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData(lat: Double, long: Double, name: String) {
        // Check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Region data
            let title = name
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            let regionRadius = 100.0
            // Setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            // Setup annotation
            let plantAnnotation = MKPointAnnotation()
            plantAnnotation.coordinate = coordinate;
            plantAnnotation.title = "\(title)";
            mapView.addAnnotation(plantAnnotation)
            // Setup circle
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            mapView.add(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    // MARK: MKMapViewDelegate for drawing the cirle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }

	// MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter region")
        monitoredRegions[region.identifier] = Date()
        updatePlants()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Remove entrance time
        monitoredRegions.removeValue(forKey: region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegionsWithLocation(location: locations[0])
    }
    
    func updatePlants() {
        let ref = FIRDatabase.database().reference(withPath: "plants")
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            self.plants = Array<Plant>()
            
            for item in snapshot.children {
                self.currentU = (FIRAuth.auth()!.currentUser?.uid)!
                let plantItem = Plant(snapshot: item as! FIRDataSnapshot)
                self.plants.append(plantItem)
            }
            self.checkIntervalPlants()
        })
    }
    
    private func checkIntervalPlants() {
        self.waterPlants = Array<Plant>()

        for plant in plants {
            let lastUpdated = Date(timeIntervalSince1970: plant.lastUpdated)
            let timeDifference = Date().timeIntervalSince(lastUpdated)
            let oneDayInSeconds = Double(plant.interval * 24 * 60 * 60)
            if timeDifference - oneDayInSeconds >= 0 {
                self.waterPlants.append(plant)
            }
        }
        
        if (self.waterPlants.count > 0) {
            DispatchQueue.main.async {
                self.showWaterAlert()
            }
        }
        // print("HOU OP: \(self.waterPlants.count)")
    }
    
    private func showWaterAlert() {
        var plantName = String()
        for plant in self.waterPlants {
            let name = plant.name
            plantName.append(name)
        }
        // print("plantnames: \(plantName) ")
        
        let alert = UIAlertController(title: plantName,
                                      message: "This little fella needs some water please",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: { action in
            for plant in self.waterPlants {                
                let post: [String: Any] = [
                    "completed" : plant.completed,
                    "info" : plant.info,
                    "interval" : plant.interval,
                    "lastUpdated": Date().timeIntervalSince1970,
                    "latitude" : plant.latitude,
                    "longitude" : plant.longitude,
                    "name" : plant.name,
                    "uid" : plant.uid
                ]
                let childUpdate = [ "\(plant.key)": post ]
                self.ref.updateChildValues(childUpdate)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func updateRegionsWithLocation(location: CLLocation) {
        let regionMaxVisiting = 20.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                regionsToDelete.append(regionIdentifier)
            }
        }
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValue(forKey: regionIdentifier)
        }
    }
    
    // MARK: Actions
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toCurrentUserLocation(_ sender: Any) {
        mapView.zoomToUserLocation()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

extension GeoViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
}
