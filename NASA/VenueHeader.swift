//
//  VenueHeader.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class VenueHeader: NSObject, JSONDecodable {
    let id: String
    let name: String
    let contact: VenueContact
    let location: VenueLocation
    let categories: [VenueCategory]
    let verified: Bool
    let stats: VenueStats
    let url: String?
    var hours: FoursquareHours? = nil
    var popular: FoursquareHours? = nil
    var menu: FoursquareMenu? = nil
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let contact = VenueContact(with: json["contact"] as! JSON),
            let location = VenueLocation(with: json["location"] as! JSON),
            let categories = [VenueCategory](with: json["categories"] as? JSONArray),
            let verified = json["verified"] as? Bool,
            let stats = VenueStats(with: json["stats"] as! JSON)
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

extension VenueHeader {
    var debugInfo: String {
        return "\(self): {\n\t\"id\":\(self.id),\n\t\"name\":\(self.name),\n\t\"contact\":\(self.contact),\n\t\"location\":\(self.location),\n\t\"categories\":\(self.categories),\n\t\"verified\":\(self.verified),\n\t\"stats\":\(self.stats),\n\t\"url\":\(self.url),\n\t\"hours\":\(self.hours),\n\t\"popular\":\(self.popular),\n\t\"menu\":\(self.menu)\n}"
    }
}
