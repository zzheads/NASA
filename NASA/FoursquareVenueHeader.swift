//
//  VenueHeader.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareVenueHeader: NSObject, JSONDecodable {
    let id: String
    let name: String
    let contact: FoursquareContact
    let location: FoursquareLocation
    let categories: [FoursquareCategory]
    let verified: Bool
    let stats: FoursquareStats
    let url: String?
    var hours: FoursquareHours? = nil
    var popular: FoursquareHours? = nil
    var menu: FoursquareMenu? = nil
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let contact = FoursquareContact(with: json["contact"] as! JSON),
            let location = FoursquareLocation(with: json["location"] as! JSON),
            let categories = [FoursquareCategory](with: json["categories"] as? JSONArray),
            let verified = json["verified"] as? Bool,
            let stats = FoursquareStats(with: json["stats"] as! JSON)
            else {
                return nil
        }
        
        self.url = json["url"] as? String
        if let hoursJson = json["hours"] as? JSON {
            self.hours = FoursquareHours(with: hoursJson)
        }
        if let popularJson = json["popular"] as? JSON {
            self.popular = FoursquareHours(with: popularJson)
        }
        if let menuJson = json["menu"] as? JSON {
            self.menu = FoursquareMenu(with: menuJson)
        }
        
        self.id = id
        self.name = name
        self.contact = contact
        self.location = location
        self.categories = categories
        self.verified = verified
        self.stats = stats
        
        super.init()
    }
    
    static func nameOfArrayInJSON() -> String {
        return "venues"
    }
}

extension FoursquareVenueHeader {
    var debugInfo: String {
        return "\(String(describing: type(of: self))): {\n\t\"id\":\(self.id),\n\t\"name\":\(self.name),\n\t\"contact\":\(self.contact.debugInfo),\n\t\"location\":\(self.location.debugInfo),\n\t\"categories\":\(self.categories.debugInfo),\n\t\"verified\":\(self.verified),\n\t\"stats\":\(self.stats),\n\t\"url\":\(self.url),\n\t\"hours\":\(self.hours),\n\t\"popular\":\(self.popular),\n\t\"menu\":\(self.menu)\n}"
    }
}
