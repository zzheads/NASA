//
//  LandsatImage.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class LandsatImage: LandsatImageHeader {
    let url: String
    let cloud_score: Double?
    
    required init?(with json: JSON) {
        guard
            let url = json["url"] as? String
            else {
                return nil
        }
        let cloud_score = json["cloud_score"] as? Double
        
        self.url = url
        self.cloud_score = cloud_score
        super.init(with: json)
    }
}

extension LandsatImage {
    override var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"date\": \(self.date),\n\t\"url\": \(self.url),\n\t\"cloud_score\": \(self.cloud_score)\n}"
    }
    
    var securedUrl: URL {
        return URL(string: self.url.replacingOccurrences(of: "http", with: "https").replacingOccurrences(of: "httpss", with: "https"))!
    }
}
