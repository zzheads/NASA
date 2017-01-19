//
//  FoursquareMayor.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//Field	Description	"Mini" Object	Compact Object	Complete Object
//id	A unique identifier for this user.	✓	✓	✓
//firstName	A user's first name.	✓	✓	✓
//lastName	A user's last name.	✓	✓	✓
//photo	Contains prefix and suffix, similar to the format for photo. Accepted sizes are 36x36, 100x100, 300x300, and 500x500.	✓	✓	✓
//relationship	The relationship of the acting user (me) to this user (them). One of self, friend, pendingMe (user has sent a friend request that acting user has not accepted), pendingThem (acting user has sent a friend request to the user but they have not accepted), or followingThem (acting user is following a celebrity or page). If there is no relationship or pending request between the two users, the node is absent. If the acting user is a celebrity, does not indicate whether the user is following them.
//
//If pendingme, applications will want to the acting user to an approve/ignore action. If pendingthem, applications will want to show the acting user a "pending" message.	○	○	○
//friends	Contains count of friends for this user and groups of users who are friends. Right now will only contain a group where type is  friends, but it's subject to change. Groups are omitted when viewing  self The full set of friends is at users/XXX/friends.	○	○	○
//type	Present for non-standard user types. One of page, chain, celebrity, or venuePage. Pages are brand pages, such as Bravo, chains are pages that own a set of venues, like Starbucks, celebrities are users that other users can follow, like Mario Batali, and venuePages represent single venues creating content, such as My ArenA creating updates. venuePage's do not really have a user profile, show the veue page instead.	○	○	○
//venue	For venuePage users, this field just contains an id for the relevant venue.	○	○	○
//homeCity	User's home city		✓	✓
//gender	male, female, or none		✓	✓
//contact	An object containing none, some, or all of twitter, facebook, email, and phone. Both are strings.		✓	✓
//bio	A short bio for the user.		○	○
//tips	In compact users, if present, contains the count of tips from this user. In full users, contains count and an array of selected tips as items, which may or may not be empty. Full set of items at users/XXX/tips		○	○
//lists	If this user has lists, groups contains created for lists created by this user. In compact, just the count is provided, and in full, some sample lists are included. In full form, lists also contains a count of the lists created and followed by this user. Full set of items at users/XXX/lists		○	○
//followers	If this user can have followers (i.e. it's a celebrity, venue, or page), contains count of followers for this user in compact, and, in detail, groups of users who follow this user, split into friends and others.		○	○
//following	groups of pages this user has followed.			✓
//mayorships	Contains the count of mayorships for this user and an items array that for now is empty. Use users/XXX/mayorships to get actual mayorships.			✓
//photos	Contains the count of photos this user has. May contain an array of selected photos as items, full set of items at users/XXX/photos, but only visible to self.			✓
//scores	Contains recent, max, checkinsCount, and goal for showing user's current game status.			✓
//checkins	Contains the count of checkins by this user. May contain the most recent checkin as an array items containing a single element, if the user is a friend. Users can fetch users/XXX/checkins for their own complete history.			✓
//pageInfo	Contains a detailed page, if they are a page.			○
//pings	Whether we receive pings from this user, if we have a relationship.			○
//requests	Contains count of pending friend requests for this user.			○

class FoursquareMiniHeaderUser: NSObject, JSONDecodable {
    let id: String
    let firstName: String
    let lastName: String
    let photo: FoursquarePhoto
    var relationship: Relationship? = nil
    var friends: [FoursquareFriend]? = nil
    var type: UserType? = nil
    var venue: String? = nil
    
    enum Relationship: String {
        case myself
        case friends
        case pendingMe
        case pendingThem
        case followingThem
    }
    
    enum UserType: String {
        case page
        case chain
        case celebrity
        case venuePage
    }
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let firstName = json["firstName"] as? String,
            let lastName = json["lastName"] as? String,
            let photoJson = json["photo"] as? JSON,
            let photo = FoursquarePhoto(with: photoJson)
            else {
                return nil
        }
        if let relationship = json["relationship"] as? String {
            self.relationship = Relationship(rawValue: relationship)
        }
        if let friends = json["friends"] as? JSONArray {
            self.friends = [FoursquareFriend](with: friends)
        }
        if let type = json["type"] as? String {
            self.type = UserType(rawValue: type)
        }
        self.venue = json["venue"] as? String
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo = photo
        
        super.init()
    }
}
