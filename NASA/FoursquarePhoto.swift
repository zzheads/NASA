//
//  FoursquarePhoto.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//id	A unique string identifier for this photo.	✓
//createdAt	Seconds since epoch when this photo was created.	✓
//prefix	Start of the URL for this photo.	✓
//suffix	Ending of the URL for this photo.
//    
//To assemble a resolvable photo URL, take prefix + size + suffix, e.g. https://irs0.4sqi.net/img/general/300x500/2341723_vt1Kr-SfmRmdge-M7b4KNgX2_PHElyVbYL65pMnxEQw.jpg.
//
//size can be one of the following, where XX or YY is one of 36, 100, 300, or 500.
//XXxYY
//original: the original photo's size
//capXX: cap the photo with a width or height of XX (whichever is larger). Scales the other, smaller dimension proportionally
//widthXX: forces the width to be XX and scales the height proportionally
//heightYY: forces the height to be YY and scales the width proportionally
//✓
//visibility	Can be one of "public" (everybody can see, including on the venue page), "friends" (only the poster's friends can see), or "private" (only the poster can see)	✓
//source	If present, the name and url for the application that created this photo.	○
//user	If the user is not clear from context, then a compact user is present.	○
//venue	If the venue is not clear from context, then a compact venue is present.	○
//tip	If the tip is not clear from context, then a compact tip is present.	○
//checkin	If the checkin is not clear from context, then a compact checkin is present.	○

class FoursquarePhoto: FoursquarePhotoHeader {
    let id: String
    let createdAt: Double
    let visibility: VisibilityPhoto
    let source: String?
    let user: FoursquareUserHeader?
    let venue: FoursquareVenueHeader?
    let tip: FoursquareTipsItem?
    let checkin: FoursquareCheckinHeader?
    
    enum VisibilityPhoto: String {
        case public
        case friends
        case private
    }
    
    init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let createdAt = json["createdAt"] as? Double,
            let visibilityValue = json["visibility"] as? String,
            let visibility = VisibilityPhoto(rawValue: visibilityValue)
            else {
                return nil
        }
        
        let source = json["source"] as? String
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
        if let tipJson = json["tip"] as? JSON {
            self.tip = FoursquareTipsItem(with: tipJson)
        } else {
            self.tip = nil
        }
        if let checkinJson = json["checkin"] as? JSON {
            self.checkin = FoursquareCheckinHeader(with: checkinJson)
        } else {
            self.checkin = nil
        }
        
        self.id = id
        self.createdAt = createdAt
        self.visibility = visibility
        
        super.init(with: json)
    }
}
