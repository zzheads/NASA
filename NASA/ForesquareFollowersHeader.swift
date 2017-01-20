//
//  ForesquareFollowersHeader.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareFollowersHeader: NSObject, JSONDecodable {
    let count: Int
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int
            else {
                return nil
        }
        self.count = count
        super.init()
    }
}
