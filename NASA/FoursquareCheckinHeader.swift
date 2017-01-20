//
//  FoursquareCheckinHeader.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//id	A unique identifier for this checkin.	✓	✓
//type	One of checkin, shout, or venueless.	✓	✓
//timeZoneOffset	The offset in minutes between when this check-in occurred and the same time in UTC. For example, a check-in that happened at -0500 UTC will have a timeZoneOffset of -300.	✓	✓
//createdAt	Seconds since epoch when this checkin was created.	✓	✓
//private	If present, it indicates the checkin was marked as private and not sent to friends. It is only being returned because the owner of the checkin is viewing this data.	○	○
//shout	Message from check-in, if present and visible to the acting user.	○	○

class FoursquareCheckinHeader: NSObject, JSONDecodable {
    let id: String
    let type: CheckinType
    let timeZoneOffset: Int
    let createdAt: Double
    let privateFlag: Bool
    let shout: String?
    
    enum CheckinType: String {
        case checkin
        case shout
        case venueless
    }
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let typeValue = json["type"] as? String,
            let type = CheckinType(rawValue: typeValue),
            let timeZoneOffset = json["timeZoneOffset"] as? Int,
            let createdAt = json["createdAt"] as? Double
            else {
                return nil
        }
            
        if let _ = json["private"] as? String {
            self.privateFlag = true
        } else {
            self.privateFlag = false
        }
        self.shout = json["shout"] as? String
        
        self.id = id
        self.type = type
        self.timeZoneOffset = timeZoneOffset
        self.createdAt = createdAt
            
        super.init()
    }
}
