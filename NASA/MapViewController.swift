//
//  ViewController.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    let locationManager = LocationManager()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        let apiClient = FoursquareAPIClient(config: .default)
        
        let coord = CLLocationCoordinate2D(latitude: 37.33, longitude: -122.031)
        
        apiClient.fetch(endpoint: .Venue(endpoint: .search(coordinate: coord, near: nil, query: nil, limit: nil, intent: nil, radius: nil, category: nil))) { (result: APIResult<FoursquareResponseWithArray<FoursquareVenueHeader>>) in
            switch result {
            case .Success(let response):
                print(response.meta.debugInfo)
                print(response.response.debugInfo)
            case .Failure(let error):
                print("\(error)")
            }
        }

        if (!self.locationManager.isAuthtorized) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        // FIXME: error handling when user did not allow location usage
        if (LocationManager.locationServicesEnabled()) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        }

        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
}

// MARK: - Handling Events Here
extension MapViewController {
    @IBAction func currentLocationPressed() {
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "MKAnnotationView")
        view.tintColor = .green
        return view
    }
}

