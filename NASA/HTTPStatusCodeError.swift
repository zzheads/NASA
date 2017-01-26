//
//  HTTPStatusError.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

enum HTTPStatusCodeError: Int, Error {
    case MultipleChoices = 300
    case MovedPermanently = 301
    case MovedTemporarily = 302
    case SeeOther = 303
    case NotModified = 304
    case UseProxy = 305
    case TemporaryRedirect = 307
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURITooLarge = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case UnprocessableEntity = 422
    case Locked = 423
    case FailedDependency = 424
    case UnorderedCollection = 425
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests = 429
    case RequestHeaderFieldsTooLarge = 431
    case RequestedHostUnavailable = 434
    case NotStandartCode = 444
    case RetryWith = 449
    case UnavailableForLegalReasons = 451
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case VariantAlsoNegotiates = 506
    case InsufficientStorage = 507
    case LoopDetected = 508
    case BandwidthLimitExceeded = 509
    case NotExtended = 510
    case NetworkAuthenticationRequired = 511
    case UnknownHTTPStatusCode = 1000
    
    var description: String {
        switch self {
        case .MultipleChoices: return "Multiple Choices"
        case .MovedPermanently: return "Moved Permanently"
        case .MovedTemporarily: return "Moved Temporarily"
        case .SeeOther: return "See Other"
        case .NotModified: return "Not Modified"
        case .UseProxy: return "Use Proxy"
        case .TemporaryRedirect: return "Temporary Redirect"
        case .BadRequest: return "Bad Request"
        case .Unauthorized: return "Unauthorized"
        case .PaymentRequired: return "Payment Required"
        case .Forbidden: return "Forbidden"
        case .NotFound: return "Not Found"
        case .MethodNotAllowed: return "Method Not Allowed"
        case .NotAcceptable: return "Not Acceptable"
        case .ProxyAuthenticationRequired: return "Proxy Authentication Required"
        case .RequestTimeout: return "Request Timeout"
        case .Conflict: return "Conflict"
        case .Gone: return "Gone"
        case .LengthRequired: return "Length Required"
        case .PreconditionFailed: return "Precondition Failed"
        case .RequestEntityTooLarge: return "Request Entity Too Large"
        case .RequestURITooLarge: return "Request URI Too Large"
        case .UnsupportedMediaType: return "Unsupported Media Type"
        case .RequestedRangeNotSatisfiable: return "Requested Range Not Satisfiable"
        case .ExpectationFailed: return "Expectation Failed"
        case .UnprocessableEntity: return "Unprocessable Entity"
        case .Locked: return "Locked"
        case .FailedDependency: return "Failed Dependency"
        case .UnorderedCollection: return "Unordered Collection"
        case .UpgradeRequired: return "Upgrade Required"
        case .PreconditionRequired: return "Precondition Required"
        case .TooManyRequests: return "Too Many Requests"
        case .RequestHeaderFieldsTooLarge: return "Request Header Fields Too Large"
        case .RequestedHostUnavailable: return "Requested Host Unavailable"
        case .NotStandartCode: return "Not Standart Code"
        case .RetryWith: return "Retry With"
        case .UnavailableForLegalReasons: return "Unavailable For Legal Reasons"
        case .InternalServerError: return "Internal Server Error"
        case .NotImplemented: return "Not Implemented"
        case .BadGateway: return "Bad Gateway"
        case .ServiceUnavailable: return "Service Unavailable"
        case .GatewayTimeout: return "Gateway Timeout"
        case .HTTPVersionNotSupported: return "HTTP Version Not Supported"
        case .VariantAlsoNegotiates: return "Variant Also Negotiates"
        case .InsufficientStorage: return "Insufficient Storage"
        case .LoopDetected: return "Loop Detected"
        case .BandwidthLimitExceeded: return "Bandwidth Limit Exceeded"
        case .NotExtended: return "Not Extended"
        case .NetworkAuthenticationRequired: return "Network Authentication Required"
        case .UnknownHTTPStatusCode: return "Unknown HTTPS Status Code"
        }
    }
}

enum APIError: Int, Error {
    case BadData
    
    var description: String {
        switch self {
        case .BadData: return "Bad data format, can not serialize it."
        }
    }
}
