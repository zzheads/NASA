//
//  VenueCategory.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class VenueCategory: NSObject, JSONDecodable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: FoursquareIcon
    let primary: Bool?
    let categories: [VenueCategory]?
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let pluralName = json["pluralName"] as? String,
            let shortName = json["shortName"] as? String,
            let icon = FoursquareIcon(with: json["icon"] as! JSON)
            else {
                return nil
        }
        let primary = json["primary"] as? Bool
        let categories = [VenueCategory](with: json["categories"] as? JSONArray)
        
        self.id = id
        self.name = name
        self.pluralName = pluralName
        self.shortName = shortName
        self.icon = icon
        self.primary = primary
        self.categories = categories
        
        super.init()
    }
}
