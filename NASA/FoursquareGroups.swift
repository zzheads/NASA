//
//  FoursquareGroups.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareGroups: NSObject, JSONDecodable {
    let friends: [FoursquareUserHeader]
    let others: [FoursquareUserHeader]
    
    required init?(with json: JSON) {
        guard
            let friendsJson = json["friends"] as? [JSON],
            let friends = [FoursquareUserHeader](with: friendsJson),
            let othersJson = json["others"] as? [JSON],
            let others = [FoursquareUserHeader](with: othersJson)
            else {
                return nil
        }
        
        self.friends = friends
        self.others = others
        super.init()
    }
}
