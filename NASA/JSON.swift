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
    static func nameOfItemInJson() -> String
    var debugInfo: String { get }
}

extension JSONDecodable {
    static func nameOfArrayInJSON() -> String {
        return "\(self)".lowercased()
    }
    static func nameOfItemInJson() -> String {
        return "\(self)".lowercased()
    }
    var debugInfo: String {
        return "\(self)"
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
    
    var debugInfo: String {
        let elements = self.map({ return "\($0.self.debugInfo)" })
        var info = "\(String(describing: type(of: self))): {"
        var count = 1
        for element in elements {
            info += "\n\t\(count). \(element),"
            count += 1
        }
        info += "\n}"
        return info
    }
}
