//
//  FoursquarePhotos.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquarePhotos: NSObject, JSONDecodable {
    let count: Int
    let items: [FoursquarePhoto]?
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int
            else {
                return nil
        }
        if let itemsJson = json["items"] as? [JSON] {
            self.items = [FoursquarePhoto](with: itemsJson)
        } else {
            self.items = nil
        }
        self.count = count
        super.init()
    }
}
