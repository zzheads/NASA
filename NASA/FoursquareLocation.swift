//
//  VenueLocation.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareLocation: NSObject, JSONDecodable {
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

extension FoursquareLocation {
    var debugInfo: String {
        var info = "\(String(describing: type(of: self))): {"
        if let address = self.address {
            info += "\n\t\"address\": \(address),"
        }
        if let crossStreet = self.crossStreet {
            info += "\n\t\"crossStreet\": \(crossStreet),"
        }
        if let city = self.city {
            info += "\n\t\"city\": \(city),"
        }
        if let state = self.state {
            info += "\n\t\"state\": \(state),"
        }
        if let postalCode = self.postalCode {
            info += "\n\t\"postalCode\": \(postalCode),"
        }
        if let country = self.country {
            info += "\n\t\"country\": \(country),"
        }
        if let lat = self.lat {
            info += "\n\t\"lat\": \(lat),"
        }
        if let lng = self.lng {
            info += "\n\t\"lng\": \(lng),"
        }
        if let distance = self.distance {
            info += "\n\t\"distance\": \(distance),"
        }
        if let isFuzzed = self.isFuzzed {
            info += "\n\t\"isFuzzed\": \(isFuzzed),"
        }
        info += "\n}"
        return info
    }
}
