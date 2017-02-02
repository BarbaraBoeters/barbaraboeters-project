//
//  PlantLocationViewController.swift
//  barbaraboeters-project
//
//  In this view the user can choose a location by using his or her current location, or 
//  searching for one by using the searchbar. The coordinates of the location are being saved
//  in the AddPlantViewController by using a segue.
//
//  Created by Barbara Boeters on 23-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlantLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomButton: UIButton!
    
    // MARK: Properties
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    var chosenLatitude: Double?
    var chosenLongitude: Double?
    
    var segueIdentifier = "mylocation"
    var segueIdentifier2 = "chosenlocation"

    override func viewDidLoad() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Actions
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchBar.resignFirstResponder()
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                self.errorMessage(title: "Error", text: "Place Not Found")
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.chosenLatitude = localSearchResponse!.boundingRegion.center.latitude
            self.chosenLongitude = localSearchResponse!.boundingRegion.center.longitude
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.searchBar.text = ""
        }
    }
    
    @IBAction func toCurrentLocation(_ sender: Any) {
        mapView.zoomToUserLocation()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func dropAnnotationPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Here am I"
        self.mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if latitude != nil && longitude != nil {
                let destination = segue.destination as? AddPlantViewController
                destination?.latitude = latitude
                destination?.longitude = longitude
            } else {
                errorMessage(title: "Error", text: "Your current location is not found")
            }
        }
        
        
        if segue.identifier == segueIdentifier2 {
            if chosenLatitude != nil && chosenLongitude != nil {
                let destination = segue.destination as? AddPlantViewController
                destination?.latitude = chosenLatitude
                destination?.longitude = chosenLatitude
            } else {
                errorMessage(title: "Error", text: "There is no location")
            }
        }
    }
    
    func errorMessage(title: String, text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}

extension PlantLocationViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
}
