//
//  ForesquareFollowers.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareFollowers: FoursquareFollowersHeader {
    let friends: JSON?
    let others: JSON?
    
    required init?(with json: JSON) {
        let friends = json["friends"] as? JSON
        let others = json["others"] as? JSON
        
        self.friends = friends
        self.others = others
        
        super.init(with: json)
    }
}
