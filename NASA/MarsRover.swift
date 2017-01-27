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
    
    init(id: Int, name: String, landing_date: String, launch_date: String, status: String, max_sol: Int, total_photos: Int, type: NASAEndpoints.Rover?) {
        self.id = id
        self.name = name
        self.landing_date = landing_date
        self.launch_date = launch_date
        self.status = status
        self.max_sol = max_sol
        self.total_photos = total_photos
        self.type = type
        super.init()
    }
    
    required convenience init?(with json: JSON) {
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
        self.init(id: id, name: name, landing_date: landing_date, launch_date: launch_date, status: status, max_sol: max_sol, total_photos: total_photos, type: NASAEndpoints.Rover(rawValue: name))
    }
}

extension MarsRover {
    var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"name\": \(self.name),\n\t\"landing_date\": \(self.landing_date),\n\t\"launch_date\": \(self.launch_date)\n\t\"status\": \(self.status),\n\t\"max_sol\": \(self.max_sol),\n\t\"total_photos\": \(self.total_photos),\n\t\"type\": \(self.type)\n}"
    }
}
