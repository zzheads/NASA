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
