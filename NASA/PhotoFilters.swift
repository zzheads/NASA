//
//  FilteredImageBuilder.swift
//  NASA
//
//  Created by Alexey Papin on 27.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import Nuke

enum PhotoFilters: String {
    case pixellate = "Pixellate"
    case colorControls = "ColorControls"
    case photoEffectInstant = "PhotoEffectInstant"
    case photoEffectProcess = "PhotoEffectProcess"
    case photoEffectNoir = "PhotoEffectNoir"
    case sepiaTone = "SepiaTone"

    static let all: [PhotoFilters] = [.pixellate, .colorControls, .photoEffectInstant, .photoEffectProcess, .photoEffectNoir, .sepiaTone]
    
    var name: String {
        switch self {
        case .pixellate: return "CIPixellate"
        case .colorControls: return "CIColorControls"
        case .photoEffectInstant: return "CIPhotoEffectInstant"
        case .photoEffectProcess: return "CIPhotoEffectProcess"
        case .photoEffectNoir: return "CIPhotoEffectNoir"
        case .sepiaTone: return "CISepiaTone"
        }
    }
        
    var defaultParameters: [String: Any]? {
        switch self {
        case .pixellate: return nil
        case .colorControls: return [kCIInputSaturationKey: 0.1]
        case .photoEffectInstant: return nil
        case .photoEffectProcess: return nil
        case .photoEffectNoir: return nil
        case .sepiaTone: return [kCIInputIntensityKey: 0.7]
        }
    }
    
    var filter: CIFilter {
        return CIFilter(name: self.name, withInputParameters: self.defaultParameters)!
    }
}
