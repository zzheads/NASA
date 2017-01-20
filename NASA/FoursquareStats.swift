//
//  VenueStats.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareStats: NSObject, JSONDecodable {
    let checkinsCount: Int
    let usersCount: Int
    let tipCount: Int
    
    required init?(with json: JSON) {
        guard
            let checkinsCount = json["checkinsCount"] as? Int,
            let usersCount = json["usersCount"] as? Int,
            let tipCount = json["tipCount"] as? Int
            else {
                return nil
        }
        
        self.checkinsCount = checkinsCount
        self.usersCount = usersCount
        self.tipCount = tipCount
        
        super.init()
    }
}
