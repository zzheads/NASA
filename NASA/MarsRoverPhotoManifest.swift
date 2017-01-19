//
//  MarsRoverPhotoManifest.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRoverPhotoManifest: NSObject, JSONDecodable {
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
    let max_sol: Int
    let max_date: String
    let total_photos: Int
    let photos: [MarsRoverPhotoHeader]

    required init?(with json: JSON) {
        guard
            let manifest = json["photo_manifest"] as? JSON,
            let name = manifest["name"] as? String,
            let landing_date = manifest["landing_date"] as? String,
            let launch_date = manifest["launch_date"] as? String,
            let status = manifest["status"] as? String,
            let max_sol = manifest["max_sol"] as? Int,
            let max_date = manifest["max_date"] as? String,
            let total_photos = manifest["total_photos"] as? Int,
            let photos = [MarsRoverPhotoHeader](with: manifest["photos"] as? JSONArray)
            else {
                return nil
        }
        
        self.name = name
        self.landing_date = landing_date
        self.launch_date = launch_date
        self.status = status
        self.max_sol = max_sol
        self.max_date = max_date
        self.total_photos = total_photos
        self.photos = photos
        
        super.init()
    }
}

extension MarsRoverPhotoManifest {
    var debugInfo: String {
        return "\(self): {\n\t\"name\": \(self.name),\n\t\"landing_date\": \(self.landing_date),\n\t\"launch_date\": \(self.launch_date),\n\t\"status\": \(self.status)\n\t\"max_sol\": \(self.max_sol),\n\t\"max_date\": \(self.max_date),\n\t\"total_photos\": \(self.total_photos),\n\t\"photos\": \(self.photos.debugInfo)\n}"
    }
}
