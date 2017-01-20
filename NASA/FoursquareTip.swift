//
//  FoursquareTip.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//todo	The count of users who have marked this tip todo, and  groups containing any friends who have marked it to-do. The groups included are subject to change. (Note that to-dos are only visible to friends!)		✓
//likes	The count of users who have liked this tip, and  groups containing any friends and others who have liked it. The groups included are subject to change.		✓

class FoursquareTip: FoursquareTipHeader {
    let todo: JSON
    let likes: JSON
    
    required init?(with json: JSON) {
        guard
            let todo = json["todo"] as? JSON,
            let likes = json["likes"] as? JSON
            else {
                return nil
        }
        self.todo = todo
        self.likes = likes
        super.init(with: json)
    }
}
