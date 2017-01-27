//
//  MarsRoverPhoto.swift
//  NASA
//
//  Created by Alexey Papin on 18.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

class MarsRoverPhoto: NSObject, Responsable {
    static let INSECURE_LOADS_DOMAIN = "mars.nasa.gov"
    
    static let nameOfItem: String = "photo" //?
    static let nameOfArray: String = "photos"
    
    let id: Int
    let sol: Int
    let camera: MarsRoverCamera
    let img_src: String
    let earth_date: String
    let rover: MarsRover
    
    var title: String {
        return "Rover: \(self.rover.name), Camera: \(self.camera.name), Sol: \(self.sol), EarthDate: \(self.earth_date)"
    }
    
    var securedUrl: URL? {
        let securedPath = self.img_src.replacingOccurrences(of: "http", with: "https").replacingOccurrences(of: "httpss", with: "https")
        if (img_src.contains(MarsRoverPhoto.INSECURE_LOADS_DOMAIN)) {
            return URL(string: self.img_src)
        } else {
            return URL(string: securedPath)
        }
    }
    
    init(id: Int, sol: Int, camera: MarsRoverCamera, img_src: String, earth_date: String, rover: MarsRover) {
        self.id = id
        self.sol = sol
        self.camera = camera
        self.img_src = img_src
        self.earth_date = earth_date
        self.rover = rover
        super.init()
    }
    
    required convenience init?(with json: JSON) {
        guard
            let id = json["id"] as? Int,
            let sol = json["sol"] as? Int,
            let camera = MarsRoverCamera(with: json["camera"] as! JSON),
            let img_src = json["img_src"] as? String,
            let earth_date = json["earth_date"] as? String,
            let rover = MarsRover(with: json["rover"] as! JSON)
            else {
                return nil
        }

        self.init(id: id, sol: sol, camera: camera, img_src: img_src, earth_date: earth_date, rover: rover)
    }
}

extension MarsRoverPhoto {
    var debugInfo: String {
        return "\(self): {\n\t\"id\": \(self.id),\n\t\"sol\": \(self.sol),\n\t\"camera\": \(self.camera.debugInfo),\n\t\"img_src\": \(self.img_src)\n\t\"earth_date\": \(self.earth_date),\n\t\"rover\": \(self.rover.debugInfo)\n}"
    }
    
    func nameOfArrayInJSON() -> String {
        return "photos"
    }
}
