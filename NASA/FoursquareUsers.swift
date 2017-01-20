//
//  FoursquareUsers.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareUsers: NSObject, JSONDecodable {
    let count: Int
    let groups: FoursquareGroups
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let groupsJson = json["groups"] as? JSON,
            let groups = FoursquareGroups(with: groupsJson)
            else {
                return nil
        }
        self.count = count
        self.groups = groups
        super.init()
    }
}
