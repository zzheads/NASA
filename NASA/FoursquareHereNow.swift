//
//  FoursquareHereNow.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//Information about who is here now.
//If present, there is always a count, the number of people here.
//If viewing details and there is a logged-in user, there is also a groups field with friends and others as types.

class FoursquareHereNow: NSObject, JSONDecodable {
    let count: Int
    let groups: JSON
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let groups = json["groups"] as? JSON
            else {
                return nil
        }
        self.count = count
        self.groups = groups
        super.init()
    }
}
