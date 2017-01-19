//
//  FoursquareResponse.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareResponse<T>: JSONDecodable where T:JSONDecodable {
    let response: T
    
    required init?(with json: JSON) {
        guard
        let response = json["response"] as? T
            else {
                return nil
        }
        self.response = response
    }
}

class FoursquareResponseWithArray<T>: JSONDecodable where T:JSONDecodable {
    let items: [T]
    let confident: Bool
    
    required init?(with json: JSON) {
        print("\(T.self)")
        guard
            let response = json["response"] as? JSON,
            let confident = response["confident"] as? Bool,
            let items = [T](with: response[T.nameOfArrayInJSON()] as? JSONArray)
            else {
                return nil
        }
        self.confident = confident
        self.items = items
    }
}
