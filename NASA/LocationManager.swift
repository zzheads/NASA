//
//  LocationManager.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    var isAuthtorized: Bool {
        return (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
    }
}
