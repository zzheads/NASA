//
//  MarsRoverResponse.swift
//  NASA
//
//  Created by Alexey Papin on 21.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRoverResponseWithArray<T>: NSObject, JSONDecodable where T: Responsable {
    let results: [T]
    
    required init?(with json: JSON) {
        guard
            let resultsJson = json[T.nameOfArray] as? [JSON],
            let results = [T](with: resultsJson)
            else {
                return nil
        }
        self.results = results
        super.init()
    }
}
