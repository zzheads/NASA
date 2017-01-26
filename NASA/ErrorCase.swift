//
//  ErrorCase.swift
//  NASA
//
//  Created by Alexey Papin on 26.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class ErrorCase: NSObject, JSONDecodable {
    let errors: String?
    let msg: String?
    
    required init?(with json: JSON) {
        self.errors = json["errors"] as? String
        self.msg = json["msg"] as? String
        super.init()
    }
}
