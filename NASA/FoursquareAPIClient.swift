//
//  FoursquareAPIClient.swift
//  NASA
//
//  Created by Alexey Papin on 19.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

private let debugEnabled = false

enum FoursquareEndpoints: Endpoint {
    
    static let CLIENT_ID = "44Y0RJDWFTW450C4SQD04CR31UERJEXHK1FMO1DYCLDAY5NK"
    static let CLIENT_SECRET = "RQQQ1YDCHO5O0YXIQZUXXJEWYLQ5ERSTYPWNVJWD5RNHMBDM"
    
    static let VERSION = "20170110"
    static let MODE = "Foursquare" // Could be Swarm
    
    case Venue(endpoint: VenueEndpoints)
    
    enum VenueEndpoints: Endpoint {
        case search(coordinate: CLLocationCoordinate2D?, near: String?, query: String?, limit: Int?, intent: Intent?, radius: Double?, category: Category?)
        
        enum Intent: String {
            case checkin
            case browse
            case global
            case match
        }
        
        enum Category: String {
            case food
        }
        
        var baseURL: URL {
            return URL(string: "https://api.foursquare.com")!
        }
        
        var path: String {
            var path = "/v2/venues/search"
            switch self {
            case .search(let coordinate, let near, let query, let limit, let intent, let radius, let category):
                if let coordinate = coordinate {
                    path += "?ll=\(coordinate.latitude),\(coordinate.longitude)"
                } else {
                    if let near = near {
                        path += "?near=\(near)"
                    } else {
                        return "Error: you must define one of two parameters, ll or near!"
                    }
                }
                if let query = query {
                    path += "&query=\(query)"
                }
                if let limit = limit {
                    path += "&limit=\(limit)"
                }
                if let intent = intent {
                    path += "&intent=\(intent.rawValue)"
                }
                if let radius = radius {
                    path += "&radius=\(radius)"
                }
                if let category = category {
                    path += "&categoryId=\(category)"
                }
            }
            path += "&client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=\(VERSION)"
            return path
        }
        
        var request: URLRequest {
            let url = URL(string: self.path, relativeTo: self.baseURL)!
            return URLRequest(url: url)
        }
        
    }
    
    var baseURL: URL {
        switch self {
        case .Venue(let endpoint): return endpoint.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .Venue(let endpoint): return endpoint.path
        }
    }
    
    var request: URLRequest {
        switch self {
        case .Venue(let endpoint): return endpoint.request
        }
    }
}

final class FoursquareAPIClient: APIClient {
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(config: URLSessionConfiguration) {
        self.configuration = config
    }
    
    convenience init() {
        self.init(config: .default)
    }
    
    func fetch<T>(endpoint: FoursquareEndpoints, completion: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        let request = endpoint.request
        if (debugEnabled) {
            NSLog("Request: \(request)")
        }
        fetch(request: request, parse: { json -> T? in
            let value = T(with: json)
            if (debugEnabled) {
                print("Parsed to \(T.self): \(value)")
            }
            return value
        }, completion: completion)
    }
    
}

