//
//  FoursquareIcon.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareIcon: NSObject, JSONDecodable {
    let prefix: String
    let suffix: String
    
    enum IconSize: String {
        case clear_32 = "32"
        case clear_44 = "44"
        case clear_64 = "64"
        case clear_88 = "88"
        case gray_32 = "bg_32"
        case gray_44 = "bg_44"
        case gray_64 = "bg_64"
        case gray_88 = "bg_88"
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
    
    func name(size: IconSize) -> String {
        return "\(self.prefix)_\(size.rawValue).\(self.suffix)"
    }
}
