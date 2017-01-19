//
//  LandsatImagesAsset.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class LandsatImageAsset: NSObject, JSONDecodable {
    let count: Int
    var results: [LandsatImageHeader]
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? Int,
            let results = [LandsatImageHeader](with: json["results"] as? JSONArray)
            else {
                return nil
        }
        self.count = count
        self.results = results
        
        super.init()
    }
}

extension LandsatImageAsset {
    var debugInfo: String {
        return "\(self): {\n\t\"count\": \(self.count),\n\t\"results\": \(self.results.debugInfo)\n}"
    }
}
