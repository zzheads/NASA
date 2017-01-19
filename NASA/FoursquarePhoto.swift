//
//  FoursquarePhoto.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquarePhoto: NSObject, JSONDecodable {
    let prefix: String
    let suffix: String
    
    enum PhotoSize: String {
        case x36 = "36x36"
        case x100 = "100x100"
        case x300 = "300x300"
        case x500 = "500x500"
    }
    
    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
        super.init()
    }
    
    required convenience init?(with json: JSON) {
        guard
            let prefix = json["prefix"] as? String,
            let suffix = json["suffix"] as? String
            else {
                return nil
        }
        self.init(prefix: prefix, suffix: suffix)
    }
    
    func name(size: PhotoSize) -> String {
        return "\(self.prefix)_\(size.rawValue).\(self.suffix)"
    }
}
