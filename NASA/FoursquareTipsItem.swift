//
//  ForesquareTipsItem.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

//USER_ID	HZXXY3Y	Identity of the user to get tips from. Pass self to get tips of the acting user.
//sort	recent	One of recent, nearby, or popular. Nearby requires geolat and geolong to be provided.
//ll	33.7,44.2	Latitude and longitude of the user's location.
//limit	100	Number of results to return, up to 500.
//offset	100	Used to page through results.

class FoursquareTipsItem: NSObject, JSONDecodable {
    let id: String?
    let sort: SortTipsItem?
    let ll: CLLocationCoordinate2D?
    let limit: Int?
    let offset: Int?

    enum SortTipsItem: String {
        case recent
        case nearby
        case popular
    }
    
    required init?(with json: JSON) {
        let id = json["USER_ID"] as? String
        let sort = json["sort"] as? String
        let ll = json["ll"] as? (Double, Double)
        let limit = json["limit"] as? Int
        let offset = json["offset"] as? Int
        
        self.id = id
        if let sort = sort {
            self.sort = SortTipsItem(rawValue: sort)!
        } else {
            self.sort = nil
        }
        if let ll = ll {
            self.ll = CLLocationCoordinate2D(latitude: ll.0, longitude: ll.1)
        } else {
            self.ll = nil
        }
        self.limit = limit
        self.offset = offset
        
        super.init()
    }
}
