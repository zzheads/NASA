//
//  FoursquareResponse.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class ResponseBody<T>: NSObject, JSONDecodable where T: Responsable {
    let confident: Bool
    let item: T
    
    required init?(with json: JSON) {
        guard
            let confident = json["confident"] as? Bool,
            let itemJson = json[T.nameOfItem] as? JSON,
            let item = T(with: itemJson)
            else {
                return nil
        }
        self.confident = confident
        self.item = item
        super.init()
    }
    
    var debugInfo: String {
        return "\(self): {\n\t\"confident\": \(self.confident),\n\t\"item\": \(self.item.debugInfo)\n}"
    }
}

class ResponseBodyArray<T>: NSObject, JSONDecodable where T: Responsable {
    let confident: Bool
    let items: [T]
    
    required init?(with json: JSON) {
        guard
            let confident = json["confident"] as? Bool,
            let itemsJson = json[T.nameOfArray] as? JSONArray,
            let items = [T](with: itemsJson)
            else {
                return nil
        }
        self.confident = confident
        self.items = items
        super.init()
    }
    
    var debugInfo: String {
        return "\(self): {\n\t\"confident\": \(self.confident),\n\t\"items\": \(self.items.debugInfo)\n}"
    }
}

class FoursquareResponse<T>: JSONDecodable where T:Responsable {
    let meta: FoursquareMeta
    let notifications: FoursquareNotifications?
    let response: ResponseBody<T>
    
    required init?(with json: JSON) {
        guard
            let metaJson = json["meta"] as? JSON,
            let meta = FoursquareMeta(with: metaJson),
            let responseJson = json["response"] as? JSON,
            let response = ResponseBody<T>(with: responseJson)
            else {
                return nil
        }
        if let notificationsJson = json["notifications"] as? JSON {
            self.notifications = FoursquareNotifications(with: notificationsJson)
        } else {
            self.notifications = nil
        }
        self.meta = meta
        self.response = response
    }
}

class FoursquareResponseWithArray<T>: JSONDecodable where T:Responsable {
    let meta: FoursquareMeta
    let notifications: FoursquareNotifications?
    let response: ResponseBodyArray<T>
    
    required init?(with json: JSON) {
        guard
            let metaJson = json["meta"] as? JSON,
            let meta = FoursquareMeta(with: metaJson),
            let responseJson = json["response"] as? JSON,
            let response = ResponseBodyArray<T>(with: responseJson)
            else {
                return nil
        }
        if let notificationsJson = json["notifications"] as? JSON {
            self.notifications = FoursquareNotifications(with: notificationsJson)
        } else {
            self.notifications = nil
        }
        self.meta = meta
        self.response = response
    }
}
