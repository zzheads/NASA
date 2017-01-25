//
//  Sound.swift
//  NASA
//
//  Created by Alexey Papin on 25.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class Sound: NSObject, JSONDecodable {
    let id: UInt
    let title: String
    let download_url: String
    let stream_url: String
    let license: String
    let duration: UInt
    let tag_list: String
    let last_modified: String
    let desc: String?
    
    required init?(with json: JSON) {
        guard
            let id = json["id"] as? UInt,
            let title = json["title"] as? String,
            let download_url = json["download_url"] as? String,
            let stream_url = json["stream_url"] as? String,
            let license = json["license"] as? String,
            let duration = json["duration"] as? UInt,
            let tag_list = json["tag_list"] as? String,
            let last_modified = json["last_modified"] as? String
            else {
                return nil
        }
        let desc = json["description"] as? String
        
        self.id = id
        self.title = title
        self.desc = desc
        self.download_url = download_url
        self.stream_url = stream_url
        self.license = license
        self.duration = duration
        self.tag_list = tag_list
        self.last_modified = last_modified
        
        super.init()
    }
}

extension Sound {
    var url: URL {
        return URL(string: self.download_url)!
    }
    
    var streamUrl: URL {
        return URL(string: self.stream_url)!
    }
    
    var request: URLRequest {
        return URLRequest(url: self.url)
    }
}
