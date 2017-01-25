//
//  MyLocationViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 24-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class MyLocationViewController: UIViewController {

    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.isHidden = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadAllGeotifications()
    }

    // MARK: Geotification functions
    func loadAllGeotifications() {
        geotifications = []
        guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
        for savedItem in savedItems {
            guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
            add(geotification: geotification)
        }
    }
    func saveAllGeotifications() {
        var items: [Data] = []
        for geotification in geotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geotification: Geotification) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        //        updateGeotificationsCount()
    }
    
        func remove(geotification: Geotification) {
            if let indexInArray = geotifications.index(of: geotification) {
                geotifications.remove(at: indexInArray)
            }
            mapView.removeAnnotation(geotification)
            removeRadiusOverlay(forGeotification: geotification)
            //updateGeotificationsCount()
        }
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    // MARK: Other mapview functions

    @IBAction func zoomToCurrentLocation(_ sender: Any) {
        mapView.zoomToUserLocation()
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
}

// MARK: Helper Extensions
extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension MyLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
}

