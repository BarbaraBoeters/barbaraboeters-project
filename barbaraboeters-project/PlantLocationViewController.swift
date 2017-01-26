//
//  PlantLocationViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 23-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlantLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomButton: UIButton!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
//    var delegate: PlantLocationViewControllerDelegate?
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

    //@IBAction func textFieldEditingChanged(_ sender: Any) {
        //addButton.isEnabled = !radiusTextField.text!.isEmpty
    //}
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchBar.resignFirstResponder()
        //        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            let locationthing = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            print("hereeee it is \(locationthing)")
            //let latitudething = localSearchResponse!.boundingRegion.center.latitude
            //let longitudething = localSearchResponse!.boundingRegion.center.longitude
            //print("lalala \(latitudething), \(longitudething)")
            //self.chosenLatitude = localSearchResponse!.boundingRegion.center.latitude
            //self.chosenLongitude = localSearchResponse!.boundingRegion.center.longitude
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.searchBar.text = ""
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
//        let coordinate = mapView.centerCoordinate
//        let radius = Double(radiusTextField.text!) ?? 0
//        let identifier = NSUUID().uuidString
//        let eventType: EventType = (segmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
//        delegate?.PlantLocationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, eventType: eventType)
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
        //print("locations2 = \(locValue.latitude) \(locValue.longitude)")
        latitude = locValue.latitude
        longitude = locValue.longitude
        //print("locations3 = \(latitude) \(longitude)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let destination = segue.destination as? AddPlantViewController
            destination?.latitude = latitude
            destination?.longitude = longitude
        }
        if segue.identifier == segueIdentifier2 {
            let destination = segue.destination as? AddPlantViewController
            destination?.latitude = chosenLatitude
            destination?.longitude = chosenLongitude
        }
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
