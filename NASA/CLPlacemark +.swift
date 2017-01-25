//
//  CLPlacemark +.swift
//  NASA
//
//  Created by Alexey Papin on 24.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import CoreLocation
import Contacts

extension CLPlacemark {
    var postalAddress: CNPostalAddress? {
        guard let addressdictionary = self.addressDictionary else {
            return nil
        }
        let address = CNMutablePostalAddress()
        address.street = addressdictionary["Street"] as? String ?? ""
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.country = addressdictionary["Country"] as? String ?? ""
        address.postalCode = addressdictionary["ZIP"] as? String ?? ""
        return address
    }
    
    var addressString: String? {
        guard let address = self.postalAddress else {
            return nil
        }
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: address)
    }
}
