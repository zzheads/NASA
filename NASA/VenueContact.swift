//
//  VenueContact.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class VenueContact: NSObject, JSONDecodable {
    let twitter: String?
    let phone: String?
    let formattedPhone: String?
    
    required init?(with json: JSON) {
        let twitter = json["twitter"] as? String
        let phone = json["phone"] as? String
        let formattedPhone = json["formattedPhone"] as? String
        
        self.twitter = twitter
        self.phone = phone
        self.formattedPhone = formattedPhone
        super.init()
    }
}
