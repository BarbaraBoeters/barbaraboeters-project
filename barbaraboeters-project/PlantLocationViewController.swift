//
//  PlantLocationViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 23-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import MapKit

protocol PlantLocationViewControllerDelegate {
    func PlantLocationViewController(controller: PlantLocationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, eventType: EventType)
}

class PlantLocationViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    var delegate: PlantLocationViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
    }

    @IBAction func textFieldEditingChanged(_ sender: Any) {
        addButton.isEnabled = !radiusTextField.text!.isEmpty
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let coordinate = mapView.centerCoordinate
        let radius = Double(radiusTextField.text!) ?? 0
        let identifier = NSUUID().uuidString
        let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
        delegate?.PlantLocationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, eventType: eventType)
    }
    
    @IBAction func toCurrentLocation(_ sender: Any) {
        mapView.zoomToUserLocation()
    }
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}
