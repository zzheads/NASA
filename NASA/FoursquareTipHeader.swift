//
//  FoursquareTip.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//id	A unique identifier for this tip.	✓	✓
//text	The actual tip.	✓	✓
//createdAt	Seconds since epoch when their tip was created.	✓	✓
//status	Will be todo or absent, depending on the user's relationship to the tip.	○	○
//url	A URL for more information.	○	○
//photo	If there is a photo for this tip and the tip is not already container inside of a photo element, details about the photo.	○	○
//user	If the context allows tips from multiple users, the compact user that created this tip.	○	○
//venue	If the context allows tips from multiple venues, the compact venue for this tip.	○	○

class FoursquareTipHeader: NSObject, JSONDecodable {
    let id: String
    let text: String
    let createdAt: Double
    let status: TipStatus?
    let url: String?
    let photo: FoursquarePhotoHeader?
    let user: FoursquareUserHeader?
    let venue: FoursquareVenueHeader?
    
    enum TipStatus: String {
        case todo
        case absent
    }
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let text = json["text"] as? String,
            let createdAt = json["createdAt"] as? Double
            else {
                return nil
        }
        
        if let statusValue = json["status"] as? String {
            self.status = TipStatus(rawValue: statusValue)
        } else {
            self.status = nil
        }
        self.url = json["url"] as? String
        if let photoJson = json["photo"] as? JSON {
            self.photo = FoursquarePhotoHeader(with: photoJson)
        } else {
            self.photo = nil
        }
        if let userJson = json["user"] as? JSON {
            self.user = FoursquareUserHeader(with: userJson)
        } else {
            self.user = nil
        }
        if let venueJson = json["venue"] as? JSON {
            self.venue = FoursquareVenueHeader(with: venueJson)
        } else {
            self.venue = nil
        }
        self.id = id
        self.text = text
        self.createdAt = createdAt
            
        super.init()
    }
    
}
