//
//  MarsRover.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRover: NSObject, JSONDecodable {
    let id: Int
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
    let max_sol: Int
    let total_photos: Int
    let type: NASAEndpoints.Rover?
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let landing_date = json["landing_date"] as? String,
            let launch_date = json["launch_date"] as? String,
            let status = json["status"] as? String,
            let max_sol = json["max_sol"] as? Int,
            let total_photos = json["total_photos"] as? Int
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.landing_date = landing_date
        self.launch_date = launch_date
        self.status = status
        self.max_sol = max_sol
        self.total_photos = total_photos
        self.type = NASAEndpoints.Rover(rawValue: name)
        
        super.init()
    }
}

extension MarsRover {
    var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"name\": \(self.name),\n\t\"landing_date\": \(self.landing_date),\n\t\"launch_date\": \(self.launch_date)\n\t\"status\": \(self.status),\n\t\"max_sol\": \(self.max_sol),\n\t\"total_photos\": \(self.total_photos),\n\t\"type\": \(self.type)\n}"
    }
}
