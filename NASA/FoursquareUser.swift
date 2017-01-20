//
//  FoursquareUser.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//following	groups of pages this user has followed.			✓
//mayorships	Contains the count of mayorships for this user and an items array that for now is empty. Use users/XXX/mayorships to get actual mayorships.			✓
//photos	Contains the count of photos this user has. May contain an array of selected photos as items, full set of items at users/XXX/photos, but only visible to self.			✓
//scores	Contains recent, max, checkinsCount, and goal for showing user's current game status.			✓
//checkins	Contains the count of checkins by this user. May contain the most recent checkin as an array items containing a single element, if the user is a friend. Users can fetch users/XXX/checkins for their own complete history.			✓
//pageInfo	Contains a detailed page, if they are a page.			○
//pings	Whether we receive pings from this user, if we have a relationship.			○
//requests	Contains count of pending friend requests for this user.			○

class FoursquareUser: FoursquareUserHeader {
    let following: JSON
    let mayorships: FoursquareListMayorships
    let photos: FoursquarePhotos
    let scores: FoursquareScores
    let checkins: FoursquareCheckins
    let pageInfo: JSON?
    let pings: Bool
    let requests: Int?
    
    required init?(with json: JSON) {
        guard
            let following = json["following"] as? JSON,
            let mayorshipsJson = json["mayorships"] as? JSON,
            let mayorships = FoursquareListMayorships(with: mayorshipsJson),
            let photosJson = json["photos"] as? JSON,
            let photos = FoursquarePhotos(with: photosJson),
            let scoresJson = json["scores"] as? JSON,
            let scores = FoursquareScores(with: scoresJson),
            let checkinsJson = json["checkins"] as? JSON,
            let checkins = FoursquareCheckins(with: checkinsJson)
            else {
                return nil
        }
        
        if let pageInfo = json["pageInfo"] as? JSON {
            self.pageInfo = pageInfo
        } else {
            self.pageInfo = nil
        }
        if let _ = json["pings"] as? JSON {
            self.pings = true
        } else {
            self.pings = false
        }
        self.requests = json["requests"] as? Int
        
        self.following = following
        self.mayorships = mayorships
        self.photos = photos
        self.scores = scores
        self.checkins = checkins
        
        super.init(with: json)
    }
}
