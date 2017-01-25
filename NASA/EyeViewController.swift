//
//  EyeViewController.swift
//  NASA
//
//  Created by Alexey Papin on 21.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EyeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placemarkTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapZoomStepper: UIStepper!
    @IBOutlet weak var trackButton: UIButton!
    
    let locationManager = LocationManager()
    let geocoder = CLGeocoder()
    var mapStepperValue = 0.0
    var annotation: MKPointAnnotation?
    
    var currentLocation: CLLocationCoordinate2D? {
        get {
            if let location = locationManager.location {
                return location.coordinate
            } else {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.locationTextField.text = "\(newValue.latitude),\(newValue.longitude)"
            self.geocoder.reverseGeocodeLocation(CLLocation(latitude: newValue.latitude, longitude: newValue.longitude)) { placemarks, error in
                guard
                let placemarks = placemarks,
                let placemark = placemarks.first
                    else {
                        if let error = error {
                            self.showAlert(title: "Geocoding error", message: "\(error)", style: .alert)
                        }
                        return
                }
                self.placemarkTextField.text = placemark.name
                self.addressTextField.text = placemark.addressString
                self.changeAnnotation(location: newValue, title: placemark.name)
                self.mapView.setCenter(coordinate: newValue, coordinatesDelta: 0.008)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapStepperValue = self.mapZoomStepper.value
        if (!LocationManager().isAuthtorized) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.trackButton.addTarget(self, action: #selector(self.toggleTrack(_:)), for: .touchUpInside)
        self.mapZoomStepper.addTarget(self, action: #selector(self.mapSoom(_:)), for: .touchUpInside)
        self.locationTextField.addTarget(self, action: #selector(self.locationEndEditing(_:)), for: .editingDidEndOnExit)
        self.addressTextField.addTarget(self, action: #selector(self.addressEndEditing(_:)), for: .editingDidEndOnExit)
        self.placemarkTextField.addTarget(self, action: #selector(self.addressEndEditing(_:)), for: .editingDidEndOnExit)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return (self.annotation != nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionViewController = segue.destination as! LandsatAssetTableViewController
        collectionViewController.location = self.annotation?.coordinate
        collectionViewController.placemarkName = self.placemarkTextField.text
        collectionViewController.addressName = self.addressTextField.text
    }
}

extension EyeViewController {
    @objc fileprivate func toggleTrack(_ sender: Any) {
        switch (self.mapView.userTrackingMode) {
        case .follow, .followWithHeading: self.mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        case .none: self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        self.currentLocation = mapView.userLocation.coordinate
    }
    
    @objc fileprivate func mapSoom(_ sender: UIStepper) {
        let factor = sender.value < self.mapStepperValue ? 1.5 : 1.0/1.5
        self.mapView.zoomMap(byFactor: factor)
        self.mapStepperValue = sender.value
    }
    
    @objc fileprivate func locationEndEditing(_ sender: UITextField) {
        guard
            let loc = sender.text
            else {
                return
        }
        let locComponents = loc.characters.split(separator: ",").map { (subsequense) -> String in
                return String(subsequense).replacingOccurrences(of: " ", with: "")
        }
        guard
            let latitudeString = locComponents.first,
            let longitudeString = locComponents.last,
            let latitude = Double(latitudeString),
            let longitude = Double(longitudeString)
            else {
                return
        }
        self.currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    @objc fileprivate func addressEndEditing(_ sender: UITextField) {
        guard let address = sender.text else {
            return
        }
        if (!address.isEmpty) {
            self.geocoder.geocodeAddressString(address) { placemarks, error in
                guard
                let placemarks = placemarks,
                let placemark = placemarks.first,
                let location = placemark.location
                    else {
                        if let error = error {
                            self.showAlert(title: "Geocoding error", message: "\(error)", style: .alert)
                        }
                        return
                }
                self.locationTextField.text = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                self.placemarkTextField.text = placemark.name
                self.addressTextField.text = placemark.addressString
                self.changeAnnotation(location: location.coordinate, title: placemark.name)
                self.mapView.setCenter(coordinate: location.coordinate, coordinatesDelta: 0.008)
            }
        }
    }
    
    fileprivate func changeAnnotation(location: CLLocationCoordinate2D, title: String?) {
        if let lastAnnotation = self.annotation {
            self.mapView.removeAnnotation(lastAnnotation)
        }
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = location
        newAnnotation.title = title
        self.mapView.addAnnotation(newAnnotation)
        self.annotation = newAnnotation
    }
}
