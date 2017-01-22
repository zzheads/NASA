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

enum NASAEndpoints: Endpoint {
    case APOD(date: Date?, hd: Bool?)
    case Earth(EarthEndpoint)
    case Mars(QueryPhoto)
    
    enum EarthEndpoint {
        case Imagery(CLLocationCoordinate2D, Date?, Bool?)
        case Asset(CLLocationCoordinate2D, Date?, Date?)
        
        var path: String {
            switch self {
            case .Imagery(let coordinate, let date, let cloud_score):
                var path = "/imagery?lon=\(coordinate.longitude)&lat=\(coordinate.latitude)"
                if let date = date {
                    path += "&date=\(date.toString)"
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
        case Sol(_: Rover, sol: Int?, camera: Rover.Camera?, page: Int?)
        case Earth(_: Rover, date: Date?, camera: Rover.Camera?, page: Int?)
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
                case .ALL_CAMERAS: return "Results from all cameras of that rover"
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
    static let NASA_KEY = "api_key=QzjlaXgOqA2ndpUfmLN6f8QBSMtkKx8SRptHevNO"
    
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
            case .Earth(let rover, let date, let camera, let page):
                var path = "/mars-photos/api/v1/rovers/\(rover.name)/photos?\(NASAEndpoints.NASA_KEY)"
                if let date = date {
                    path += "&earth_date=\(date.toString)"
                } else {
                    path += "&sol=1000"
                }
                if let camera = camera {
                    if (camera != .ALL_CAMERAS) {
                        path += "&camera=\(camera.name)"
                    }
                }
                if let page = page {
                    path += "&page=\(page)"
                }
                return path
                
            case .Sol(let rover, let sol, let camera, let page):
                var path = "/mars-photos/api/v1/rovers/\(rover.name)/photos?sol=\(sol)"
                if let camera = camera {
                    if (camera != .ALL_CAMERAS) {
                        path += "&camera=\(camera.name)"
                    }
                }
                if let page = page {
                    path += "&page=\(page)"
                }
                path += "&\(NASAEndpoints.NASA_KEY)"
                return path
                
            case .Manifest(let rover):
                return "/mars-photos/api/v1/manifests/\(rover.name)?\(NASAEndpoints.NASA_KEY)"
            }
        }
    }
    
    var request: URLRequest {
        let url = URL(string: self.path, relativeTo: self.baseURL)!
        let request = URLRequest(url: url)
        return request
    }
}

final class NASAAPIClient: APIClient {
    
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
    
    func fetch<T>(endpoint: NASAEndpoints, completion: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        let request = endpoint.request
        print("Request: \(request)")
        fetch(request: request, parse: { json -> T? in
            let value = T(with: json)
            //print("Parsed to \(T.self): \(value)")
            return value
        }, completion: completion)
    }
}












