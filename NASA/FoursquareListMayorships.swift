//
//  FoursquareListMayorships.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//mayorships	A count and items of objects which currently only contain compact venue objects.

class FoursquareListMayorships: NSObject, JSONDecodable {
    let count: Int
    let items: [FoursquareVenueHeader]
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let items = [FoursquareVenueHeader](with: json["items"] as? [JSON])
            else {
                return nil
        }
        self.count = count
        self.items = items
        super.init()
    }
}
