//
//  FoursquareUserHeader.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//homeCity	User's home city		✓	✓
//gender	male, female, or none		✓	✓
//contact	An object containing none, some, or all of twitter, facebook, email, and phone. Both are strings.		✓	✓
//bio	A short bio for the user.		○	○
//tips	In compact users, if present, contains the count of tips from this user. In full users, contains count and an array of selected tips as items, which may or may not be empty. Full set of items at users/XXX/tips		○	○
//lists	If this user has lists, groups contains created for lists created by this user. In compact, just the count is provided, and in full, some sample lists are included. In full form, lists also contains a count of the lists created and followed by this user. Full set of items at users/XXX/lists		○	○
//followers	If this user can have followers (i.e. it's a celebrity, venue, or page), contains count of followers for this user in compact, and, in detail, groups of users who follow this user, split into friends and others.		○

class FoursquareUserHeader: FoursquareUserMiniHeader {
    let homeCity: String
    let gender: Gender
    let contact: FoursquareContact
    let bio: String?
    let tips: FoursquareTipsHeader?
    let lists: JSON?
    let followers: FoursquareFollowersHeader?
    
    enum Gender: String {
        case male
        case female
        case none
    }
    
    required init?(with json: JSON) {
        guard
        let homeCity = json["homeCity"] as? String,
        let gender = json["gender"] as? String,
        let contactJson = json["contact"] as? JSON,
            let contact = FoursquareContact(with: contactJson)
        else {
            return nil
        }
        
        self.bio = json["bio"] as? String
        if let tipsJson = json["tips"] as? JSON {
            self.tips = FoursquareTipsHeader(with: tipsJson)
        } else {
            self.tips = nil
        }
        self.lists = json["lists"] as? JSON
        if let followersJson = json["followers"] as? JSON {
            self.followers = FoursquareFollowersHeader(with: followersJson)
        } else {
            self.followers = nil
        }
        
        self.homeCity = homeCity
        self.gender = Gender(rawValue: gender)!
        self.contact = contact
        super.init(with: json)
    }
}
