//
//  NASAAPIClient.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

private let debugEnabled = false

enum NASAEndpoints: Endpoint {
    case APOD(date: Date?, hd: Bool?)
    case Earth(EarthEndpoint)
    case Mars(QueryPhoto)
    case Sounds(search: String, limit: Int?)
    
    var rawValue: String {
        return self.request.description
    }
    
    enum EarthEndpoint {
        case Imagery(CLLocationCoordinate2D, String?, Bool?)
        case Asset(CLLocationCoordinate2D, Date?, Date?)
        
        var path: String {
            switch self {
            case .Imagery(let coordinate, let date, let cloud_score):
                var path = "/imagery?lon=\(coordinate.longitude)&lat=\(coordinate.latitude)"
                if let date = date {
                    path += "&date=\(date)"
                }
                if let cloud_score = cloud_score {
                    path += "&cloud_score=\(cloud_score.toString)"
                }
                return path
            case .Asset(let coordinate, let begin_date, let end_date):
                var path = "/assets?lon=\(coordinate.longitude)&lat=\(coordinate.latitude)"
                if let begin_date = begin_date {
                    path += "&begin=\(begin_date.toString)"
                }
                if let end_date = end_date {
                    path += "&end=\(end_date.toString)"
                }
                return path
            }
        }
    }

    enum QueryPhoto {
        case Sol(_: Rover, sol: Int, camera: Rover.Camera?)
        case Earth(_: Rover, date: Date, camera: Rover.Camera?)
        case Manifest(_: Rover)
    }

    enum Rover: String {
        case Curiosity
        case Opportunity
        case Spirit
        
        var photo: UIImage {
            switch self {
            case .Curiosity: return #imageLiteral(resourceName: "curiosity.jpg")
            case .Opportunity: return #imageLiteral(resourceName: "opportunity.jpg")
            case .Spirit: return #imageLiteral(resourceName: "spirit.jpg")
            }
        }
        
        var name: String {
            return self.rawValue.lowercased()
        }
        
        enum Camera: String, CustomStringConvertible {
            case FHAZ
            case RHAZ
            case MAST
            case CHEMCAM
            case MAHLI
            case MARDI
            case NAVCAM
            case PANCAM
            case MINITES
            case ALL_CAMERAS
            
            var name: String {
                return self.rawValue.lowercased()
            }
            
            var description: String {
                switch self {
                case .FHAZ: return "Front Hazard Avoidance Camera"
                case .RHAZ: return "Rear Hazard Avoidance Camera"
                case .MAST: return "Mast Camera"
                case .CHEMCAM: return "Chemistry and Camera Complex"
                case .MAHLI: return "Mars Hand Lens Imager"
                case .MARDI: return "Mars Descent Imager"
                case .NAVCAM: return "Navigation Camera"
                case .PANCAM: return "Panoramic Camera"
                case .MINITES: return "Miniature Thermal Emission Spectrometer (Mini-TES)"
                case .ALL_CAMERAS: return "All cameras"
                }
            }
        }
        
        var cameras: [Camera] {
            switch self {
            case .Curiosity: return [.FHAZ, .RHAZ, .MAST, .CHEMCAM, .MAHLI, .MARDI, .NAVCAM, .ALL_CAMERAS]
            case .Opportunity, .Spirit: return [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES, .ALL_CAMERAS]
            }
        }
    }
    
    static let basePath = "https://api.nasa.gov"
    static let NASA_KEY_3 = "api_key=QzjlaXgOqA2ndpUfmLN6f8QBSMtkKx8SRptHevNO"
    static let NASA_KEY = "api_key=TDU5YvbqFysrFepeYXZInSxpIWbSQuYEKDkt2nPL"
    static let NASA_KEY_2 = "api_key=zWgiWkxGZ693SKtOwsbpuPdTk5tRQoJvPDYw9lnL"
        
    var baseURL: URL {
        let baseURL = URL(string: NASAEndpoints.basePath)
        return baseURL!
    }
    
    var path: String {
        switch self {
        case .APOD(let date, let hd):
            var path = "/planetary/apod?\(NASAEndpoints.NASA_KEY)"
            if let date = date {
                path += "&date=\(date.toString)"
            }
            if let hd = hd {
                path += "&hd=\(hd.toString)"
            }
            return path
        case .Earth(let earthEndpoint):
            return "/planetary/earth\(earthEndpoint.path)&\(NASAEndpoints.NASA_KEY)"
        case .Mars(let query):
            switch query {
            case .Earth(let rover, let date, let camera):
                var path = "/mars-photos/api/v1/rovers/\(rover.name)/photos?earth_date=\(date.toString)"
                if let camera = camera {
                    if (camera != .ALL_CAMERAS) {
                        path += "&camera=\(camera.name)"
                    }
                }
                path += "&\(NASAEndpoints.NASA_KEY)"
                return path
                
            case .Sol(let rover, let sol, let camera):
                var path = "/mars-photos/api/v1/rovers/\(rover.name)/photos?sol=\(sol)"
                if let camera = camera {
                    if (camera != .ALL_CAMERAS) {
                        path += "&camera=\(camera.name)"
                    }
                }
                path += "&\(NASAEndpoints.NASA_KEY)"
                return path
                
            case .Manifest(let rover):
                return "/mars-photos/api/v1/manifests/\(rover.name)?\(NASAEndpoints.NASA_KEY)"
            }
        case .Sounds(let search, let limit):
            var path = "/planetary/sounds?q=\(search)"
            if let limit = limit {
                path += "&limit=\(limit)"
            }
            path += "&\(NASAEndpoints.NASA_KEY)"
            return path
        }
    }
    
    var request: URLRequest {
        let url = URL(string: self.path, relativeTo: self.baseURL)!
        let request = URLRequest(url: url)
        return request
    }
}

protocol ProgressShowing {
    func set(progress: Double)
    func update<T>(newItem: T) where T: JSONDecodable
}

final class NASAAPIClient: NSObject, APIClient {
    let configuration: URLSessionConfiguration
    let delegate: URLSessionDelegate?
    let delegateQueue: OperationQueue?
    
    lazy var session: URLSession = {
        let session = URLSession(configuration: self.configuration, delegate: self.delegate, delegateQueue: self.delegateQueue)
        return session
    }()
    
    init(config: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue: OperationQueue?) {
        self.configuration = config
        self.delegate = delegate
        self.delegateQueue = delegateQueue
    }
    
    convenience init(delegate: URLSessionDelegate?, delegateQueue: OperationQueue?) {
        self.init(config: .default, delegate: delegate, delegateQueue: delegateQueue)
    }
    
    func fetch<T>(endpoint: NASAEndpoints, completion: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        fetch(request: endpoint.request, parse: { json -> T? in return T(with: json) }, completion: completion)
        if (debugEnabled) {
            print("Fetching \(endpoint.request) to \(T.self)")
        }
    }
}










