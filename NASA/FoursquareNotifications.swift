//
//  FoursquareNotifications.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//tip	A recommended tip, generally at the current venue. Contains a type field that provides justification for showing the type (e.g., it was on the acting users to-do list, a friend liked it, etc.). If type is nearby the tip is at a different venue, which is included in the tip field.
//leaderboard	Contains a message regarding the user's leaderboard standing, a leaderboard result with neighbors=2 (includes current user's leaderboard), a total representing total points scored with the checkin, and a scores array with points, icon, and message.
//mayorship	Contains type, which is one of nochange, new, or stolen. Contains checkins, which is the number of checkins the acting user has had in the past 60 days. May contain  daysBehind for the number of days hte user is behind the mayor. May contain a user if there is or was a mayor, and that mayor is not the current user. Also contains a message intended for display to the acting user, and an image of a crown or of the current mayor.
//specials	A special available at the venue the user just checked into.
//message	Just contains a single message intended for display to the user, such as "Thanks for the tip!"
//pageUpdate	A recent update posted by the venue manager.
//venueListProgress	Notifies the user when this checkin has crossed the venue off one of the user's lists. Contains the list this venue is on, along with a type indicating if the list was the users todo list, or if it was created, edited, or followed by the user.

class FoursquareNotifications: NSObject, JSONDecodable {
    let someShit: JSON
    
    required init?(with json: JSON) {
        self.someShit = json
        super.init()
    }
}
