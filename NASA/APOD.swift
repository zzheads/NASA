//
//  APOD.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class APOD: NSObject, JSONDecodable {
    let date_string: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let service_version: String
    let title: String
    let url: String
    let copyright: String?
    
    var secureUrl: String {
        let secured = self.url.replacingOccurrences(of: "http", with: "https")
        return secured
    }
    
    required init?(with json: JSON) {
        guard
        let date_string = json["date"] as? String,
        let explanation = json["explanation"] as? String,
        let media_type = json["media_type"] as? String,
        let service_version = json["service_version"] as? String,
        let title = json["title"] as? String,
        let url = json["url"] as? String
            else {
                return nil
        }
        let copyright = json["copyright"] as? String
        let hdurl = json["hdurl"] as? String
        
        self.date_string = date_string
        self.explanation = explanation
        self.hdurl = hdurl
        self.media_type = media_type
        self.service_version = service_version
        self.title = title
        self.url = url
        self.copyright = copyright
        super.init()
    }
}

extension APOD {
    var debugInfo: String {
        return "\(self): {\n\t\"date\": \(self.date_string),\n\t\"explanation\": \(self.explanation),\n\t\"hdurl\": \(self.hdurl),\n\t\"media_type\": \(self.media_type),\n\t\"service_version\": \(self.service_version),\n\t\"title\": \(self.title),\n\t\"url\": \(self.url),\n\t\"copyright\": \(self.copyright)\n}"
    }
    
    var date: Date? {
        return self.date_string.toDate
    }
}
