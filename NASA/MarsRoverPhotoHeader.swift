//
//  MarsRoverPhotoHeader.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRoverPhotoHeader: NSObject, JSONDecodable {
    let sol: Int
    let total_photos: Int
    let cameras: [String]
    
    required init?(with json: JSON) {
        guard
            let sol = json["sol"] as? Int,
            let total_photos = json["total_photos"] as? Int,
            let cameras = json["cameras"] as? [String]
            else {
                return nil
        }
        
        self.sol = sol
        self.total_photos = total_photos
        self.cameras = cameras
        
        super.init()
    }
}

extension MarsRoverPhotoHeader {
    var debugInfo: String {
        return "\(self): {\n\t\"sol\": \(self.sol),\n\t\"total_photos\": \(self.total_photos),\n\t\"cameras\": \(self.cameras)\n}"
    }
}

extension Array where Element: MarsRoverPhotoHeader {
    var debugInfo: String {
        var info = ""
        var count = 1
        for element in self {
            info += "\n\t\t\(count). \(element.self): { \"sol\": \(element.sol), \"total_photos\": \(element.total_photos), \"cameras\": {\n\t\t\t\(element.cameras)} }"
            count += 1
        }
        return info
    }
}
