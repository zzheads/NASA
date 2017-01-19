//
//  JSON.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

typealias JSON = [String:AnyObject]
typealias JSONArray = [JSON]

typealias JSONTask = URLSessionDataTask
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    init?(with json: JSON)
    static func nameOfArrayInJSON() -> String
}

extension JSONDecodable {
    static func nameOfArrayInJSON() -> String {
        return "\(self)".lowercased()
    }
}

extension Array where Element: JSONDecodable {
    init?(with jsonArray: JSONArray?) {
        guard let jsonArray = jsonArray else {
            return nil
        }
        self.init()
        for json in jsonArray {
            if let element = Element.init(with: json) {
                self.append(element)
            }
        }
    }
}
