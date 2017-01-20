//
//  ForesquareTip.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//In compact users, if present, contains the count of tips from this user. 
//In full users, contains count and an array of selected tips as items, which may or may not be empty. Full set of items at users/XXX/tips

class FoursquareTipsHeader: NSObject, JSONDecodable {
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
