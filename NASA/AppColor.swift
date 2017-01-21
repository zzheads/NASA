//
//  AppColor.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum AppColor {
    case magentaLighten
    
    var color: UIColor {
        switch self {
        case .magentaLighten: return UIColor(red: 219/255.0, green: 214/255.0, blue: 223/255.0, alpha: 1.0)
        }
    }
}

enum AppFont {
    case sanFrancisco
    
    var font: UIFont? {
        switch self {
        case .sanFrancisco: return UIFont(name: "San Francisco Display-Medium", size: 14.0)
        }
    }
}
