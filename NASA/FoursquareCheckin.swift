//
//  FoursquareCheckin.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//user	If the user is not clear from context, then a compact user is present.		○
//venue	If the venue is not clear from context, and this checkin was at a venue, then a compact venue is present.		○
//location	If the type of this checkin is shout or venueless, this field may be present and may contains a lat, lng pair and/or a name, providing unstructured information about the user's current location.		○
//source	If present, the name and url for the application that created this checkin.		○
//event	If the user checked into an event, this field will be present, containing the id and name of the event		○
//photos	count and items for photos on this checkin. All items may not be present.		✓
//comments	count and items for comments on this checkin. All items may not be present.		✓
//likes	The count of users who have liked this checkin, and  groups containing any friends and others who have liked it. The groups included are subject to change.		✓
//overlaps	count and items of checkins from friends checked into the same venue around the same time.		○
//score	total and scores for this checkin		○

class FoursquareCheckin: FoursquareCheckinHeader {
    let user: FoursquareUserHeader?
    let venue: FoursquareVenueHeader?
    let location: JSON?
    let source: String?
    let event: String?
    let photos: FoursquarePhotos
    let comments: FoursquareComments
    let likes: FoursquareUsers
    let overlaps: FoursquareCheckins?
    let score: JSON?
    
    required init?(with json: JSON) {
        guard
            let photosJson = json["photos"] as? JSON,
            let photos = FoursquarePhotos(with: photosJson),
            let commentsJson = json["comments"] as? JSON,
            let comments = FoursquareComments(with: commentsJson),
            let likesJson = json["likes"] as? JSON,
            let likes = FoursquareUsers(with: likesJson)
            else {
                return nil
        }
        
        if let user = json["user"] as? JSON {
            self.user = FoursquareUserHeader(with: user)
        } else {
            self.user = nil
        }
        if let venue = json["venue"] as? JSON {
            self.venue = FoursquareVenueHeader(with: venue)
        } else {
            self.venue = nil
        }
        if let location = json["location"] as? JSON {
            self.location = location
        } else {
            self.location = nil
        }
        self.source = json["source"] as? String
        if let overlaps = json["overlaps"] as? JSON {
            self.overlaps = FoursquareCheckins(with: overlaps)
        } else {
            self.overlaps = nil
        }
        if let score = json["score"] as? JSON {
            self.score = score
        } else {
            self.score = nil
        }
        self.event = json["event"] as? String
        
        self.photos = photos
        self.comments = comments
        self.likes = likes
        
        super.init(with: json)
    }
    
}
