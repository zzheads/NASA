//
//  FoursquareComments.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareComments: NSObject, JSONDecodable {
    let count: Int
    let items: [JSON]
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let items = json["items"] as? [JSON]
            else {
                return nil
        }
        self.count = count
        self.items = items
        super.init()
    }
}
