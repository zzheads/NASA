//
//  FoursquarePrice.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquarePrice: NSObject, JSONDecodable {
    let tier: PriceTier
    let message: String
    
    enum PriceTier: Int {
        case leastPricey = 1
        case lessPricey = 2
        case morePricey = 3
        case mostPricey = 4
    }
    
    required init?(with json: JSON) {
        guard
            let tier = json["tier"] as? Int,
            let message = json["message"] as? String
            else {
                return nil
        }
        self.tier = PriceTier(rawValue: tier)!
        self.message = message
        super.init()
    }
}
