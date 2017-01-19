//
//  FoursquareHours.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareHours: NSObject, JSONDecodable {
    let days: [Days]
    let open: [(start: String, end: String)]
    let includesToday: Bool?
    let segments: [(label: String, start: String, end: String)]
    
    enum Days: Int {
        case monday = 1
        case tuesday = 2
        case wednesday = 3
        case thursday = 4
        case friday = 5
        case saturday = 6
        case sunday = 7
    }
    
    required init?(with json: JSON) {
        guard
            let days = json["days"] as? [Int],
            let open = json["open"] as? [(start: String, end: String)],
            let segments = json["segments"] as? [(label: String, start: String, end: String)]
            else {
                return nil
        }
        let includesToday = json["includesToday"] as? Bool
        
        self.days = days.map({return Days(rawValue: $0)!})
        self.open = open
        self.segments = segments
        self.includesToday = includesToday
        
        super.init()
    }
}
