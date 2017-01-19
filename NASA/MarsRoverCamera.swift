//
//  MarsRoverCamera.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRoverCamera: NSObject, JSONDecodable {
    let id: Int
    let name: String
    let rover_id: Int
    let full_name: String
    let type: NASAEndpoints.Rover.Camera?
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let rover_id = json["rover_id"] as? Int,
            let full_name = json["full_name"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.rover_id = rover_id
        self.full_name = full_name
        self.type = NASAEndpoints.Rover.Camera(rawValue: name)
        
        super.init()
    }
}

extension MarsRoverCamera {
    var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"name\": \(self.name),\n\t\"rover_id\": \(self.rover_id),\n\t\"full_name\": \(self.full_name)\n\t\"type\": \(self.type)\n}"
    }
}
