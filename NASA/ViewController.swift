//
//  ViewController.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        

        let apiClient = FoursquareAPIClient(config: .default)
        
        let coord = CLLocationCoordinate2D(latitude: 37.33, longitude: -122.031)
        
        apiClient.fetch(endpoint: .Venue(endpoint: .search(coordinate: coord, near: nil, query: nil, limit: nil, intent: nil, radius: nil, category: nil))) { (result: APIResult<FoursquareResponseWithArray<FoursquareVenueHeader>>) in
            switch result {
            case .Success(let response):
                response.items.map({print("\($0.debugInfo)")})
            case .Failure(let error):
                print("\(error)")
            }
        }
    }

}

