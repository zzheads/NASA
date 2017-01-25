//
//  Respond.swift
//  NASA
//
//  Created by Alexey Papin on 25.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class Response<T>: NSObject, JSONDecodable where T: JSONDecodable {
    let count: UInt
    let results: [T]
    
    required init?(with json: JSON) {
        guard
            let count = json["count"] as? UInt,
            let resultsJson = json["results"] as? JSONArray,
            let results = [T](with: resultsJson)
            else {
                return nil
        }
        self.count = count
        self.results = results
        super.init()
    }
}
