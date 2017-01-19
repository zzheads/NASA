//
//  VenueLocation.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class VenueLocation: NSObject, JSONDecodable {
    let address: String?
    let crossStreet: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
    let lat: Double?
    let lng: Double?
    let distance: Double?
    let isFuzzed: Bool?
    
    required init?(with json: JSON) {
        let address = json["address"] as? String
        let crossStreet = json["crossStreet"] as? String
        let city = json["city"] as? String
        let state = json["state"] as? String
        let postalCode = json["postalCode"] as? String
        let country = json["country"] as? String
        let lat = json["lat"] as? Double
        let lng = json["lng"] as? Double
        let distance = json["distance"] as? Double
        let isFuzzed = json["isFuzzed"] as? Bool
        
        self.address = address
        self.crossStreet = crossStreet
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.isFuzzed = isFuzzed
        
        super.init()
    }
}
