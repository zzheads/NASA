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

class FoursquareTips: FoursquareTipsHeader {
    let items: [FoursquareTipsItem]
    
    required init?(with json: JSON) {
        guard
            let itemsJson = json["items"] as? [JSON],
            let items = [FoursquareTipsItem](with: itemsJson)
            else {
                return nil
        }
        self.items = items
        super.init(with: json)
    }
}
