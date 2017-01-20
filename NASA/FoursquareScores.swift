//
//  FoursquareScores.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

//Contains recent, max, checkinsCount, and goal for showing user's current game status.

class FoursquareScores: NSObject, JSONDecodable {
    let recent: Int
    let max: Int
    let checkinsCount: Int
    let goal: Int
    
    required init?(with json: JSON) {
        guard
            let recent = json["recent"] as? Int,
            let max = json["max"] as? Int,
            let checkinsCount = json["checkinsCount"] as? Int,
            let goal = json["goal"] as? Int
            else {
                return nil
        }
        
        self.recent = recent
        self.max = max
        self.checkinsCount = checkinsCount
        self.goal = goal
            
        super.init()
    }
}
