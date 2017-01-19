//
//  LandsatImageHeader.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class LandsatImageHeader: NSObject, JSONDecodable {
    let id: String
    let date: String
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? String,
            let date = json["date"] as? String
            else {
                return nil
        }
        self.id = id
        self.date = date
        super.init()
    }
}

extension LandsatImageHeader {
    var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"date\": \(self.date)\n\t}"
    }
}

extension Array where Element: LandsatImageHeader {
    var debugInfo: String {
        var info = ""
        var count = 1
        for element in self {
            info += "\n\t\t\(count). \(element.self): { \"id\": \(element.id), \"date\": \(element.date) }"
            count += 1
        }
        return info
    }
}
