//
//  FoursquareMeta.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class FoursquareMeta: NSObject, JSONDecodable {
    let code: Int
    let requestId: String
    let errorType: ErrorType?
    let errorDetail: String?
    let errorMessage: String?
    let message: String?
    
//    invalid_auth	401	OAuth token was not provided or was invalid.
//    param_error	400	A required parameter was missing or a parameter was malformed. This is also used if the resource ID in the path is incorrect.
//    endpoint_error	404	The requested path does not exist.
//    not_authorized	403	Although authentication succeeded, the acting user is not allowed to see this information due to privacy restrictions.
//    rate_limit_exceeded	403	Rate limit for this hour exceeded.
//    deprecated	200	Something about this request is using deprecated functionality, or the response format may be about to change.
//    server_error	Varies	Server is currently experiencing issues. Check status.foursquare.com for updates.
//    other	Varies	Some other type of error occurred.
    
    enum ErrorType: String {
        case invalid_auth = "OAuth token was not provided or was invalid."
        case param_error = "A required parameter was missing or a parameter was malformed. This is also used if the resource ID in the path is incorrect."
        case endpoint_error = "The requested path does not exist."
        case not_authorized = "Although authentication succeeded, the acting user is not allowed to see this information due to privacy restrictions."
        case rate_limit_exceeded = "Rate limit for this hour exceeded."
        case deprecated	= "Something about this request is using deprecated functionality, or the response format may be about to change."
        case server_error = "Server is currently experiencing issues. Check status.foursquare.com for updates."
        case other = "Some other type of error occurred."

        var code: Int {
            switch self {
            case .invalid_auth: return 401
            case .param_error: return 400
            case .endpoint_error: return 404
            case .not_authorized: return 403
            case .rate_limit_exceeded: return 403
            case .deprecated: return 200
            case .server_error, .other: return 500
            }
        }
    }
    
    required init?(with json: JSON) {
        guard
            let code = json["code"] as? Int,
            let requestId = json["requestId"] as? String
            else {
                return nil
        }
        if let errorTypeValue = json["errorType"] as? String {
            self.errorType = ErrorType(rawValue: errorTypeValue)
        } else {
            self.errorType = nil
        }
        self.errorDetail = json["errorDetail"] as? String
        self.errorMessage = json["errorMessage"] as? String
        self.message = json["message"] as? String
        self.code = code
        self.requestId = requestId
        super.init()
    }
}

extension FoursquareMeta {
    var debugInfo: String {
        var info = "\(self): {\n\t\"code\": \(self.code)"
        if let errorType = self.errorType {
            info += ",\n\t\"errorType\": \(errorType)"
        }
        if let errorDetail = self.errorDetail {
            info += ",\n\t\"errorDetail\": \(errorDetail)"
        }
        if let errorMessage = self.errorMessage {
            info += ",\n\t\"errorMessage\": \(errorMessage)"
        }
        if let message = self.message {
            info += ",\n\t\"message\": \(message)"
        }
        info += "\n}"
        return info
    }
}
