//
//  FoursquareMenu.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareMenu: NSObject, JSONDecodable {
    let url: String
    let mobileUrl: String
    
    required init?(with json: JSON) {
        guard
            let url = json["url"] as? String,
            let mobileUrl = json["mobileUrl"] as? String
            else {
                return nil
        }
        self.url = url
        self.mobileUrl = mobileUrl
        super.init()
    }
}
