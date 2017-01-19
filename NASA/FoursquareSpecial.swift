//
//  FoursquareSpecial.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//id	A unique identifier for this special.
//type	count or frequency
//message	A message describing the special.
//description	A description of how to unlock the special.
//finePrint	The specific rules for this special.
//unlocked	True or false indicating if this special is unlocked for the acting user.
//icon	The name of the icon to use: http://foursquare.com/img/specials/icon.png
//title	The header text describing the type of special.
//state	Possible values:
//unlocked	the special is unlocked (all types)
//before start	the time after which the special may be unlocked is in the future (flash specials)
//in progress	the special is locked but could be unlocked if you check in (flash specials), or the special is locked but could be unlocked if enough of your friends check in (friends specials)
//taken	the maximum number of people have unlocked the special for the day (flash and swarm specials)
//locked	the special is locked (all other types)
//progress	A description of how close you are to unlocking the special. Either the number of people who have already unlocked the special (flash and swarm specials), or the number of your friends who have already checked in (friends specials)
//progressDescription	A label describing what the number in the progress field means.
//detail	Minutes remaining until the special can be unlocked (flash special only).
//target	A number indicating the maximum (swarm, flash) or minimum (friends) number of people allowed to unlock the special.
//friendsHere	A list of friends currently checked in, as compact user objects (friends special only).


class FoursquareSpecial: NSObject, JSONDecodable {
    let id: String
    let type: SpecialType
    let message: String
    let desc: String
    let finePrint: String
    let unlocked: Bool
    let icon: String
    let title: String
    let state: SpecialState
    let progress: Int
    let progressDescription: String
    let detail: Int
    let target: Int
    let friendsHere: [FoursquareFriend]
    
    var iconPath: String {
        return "http://foursquare.com/img/specials/\(self.icon).png"
    }
    
    enum SpecialType: String {
        case count
        case frequency
    }
    
    enum SpecialState: String {
        case unlocked
        case beforeStart
        case inProgress
        case locked
    }
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let type = json["type"] as? String,
            let message = json["message"] as? String,
            let desc = json["description"] as? String,
            let finePrint = json["finePrint"] as? String,
            let unlocked = json["unlocked"] as? Bool,
            let icon = json["icon"] as? String,
            let title = json["title"] as? String,
            let state = json["state"] as? String,
            let progress = json["progress"] as? Int,
            let progressDescription = json["progressDescription"] as? String,
            let detail = json["detail"] as? Int,
            let target = json["target"] as? Int,
            let friendsHere = [FoursquareFriend](with: json["friendsHere"] as? JSONArray)
            else {
                return nil
        }
        
        self.id = id
        self.type = SpecialType(rawValue: type)!
        self.message = message
        self.desc = desc
        self.finePrint = finePrint
        self.unlocked = unlocked
        self.icon = icon
        self.title = title
        self.state = SpecialState(rawValue: state)!
        self.progress = progress
        self.progressDescription = progressDescription
        self.detail = detail
        self.target = target
        self.friendsHere = friendsHere
        
        super.init()
    }
}
