//
//  FoursquareCheckins.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareCheckins: NSObject, JSONDecodable {
    let count: Int
    let items: [FoursquareCheckin]
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let itemsJson = json["items"] as? [JSON],
            let items = [FoursquareCheckin](with: itemsJson)
            else {
                return nil
        }
        self.count = count
        self.items = items
        super.init()
    }
}
