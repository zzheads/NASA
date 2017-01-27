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
    case colorClamp = "CIColorClamp"
    case colorControls = "CIColorControls"
    case photoEffectInstant = "CIPhotoEffectInstant"
    case photoEffectProcess = "CIPhotoEffectProcess"
    case photoEffectNoir = "CIPhotoEffectNoir"
    case sepiaTone = "CISepiaTone"

    var defaultParameters: [String: Any]? {
        switch self {
        case .colorClamp = return ["inputMinComponents": CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), "inputMaxComponents": CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9)]
        case .colorControls = "CIColorControls"
        case .photoEffectInstant = "CIPhotoEffectInstant"
        case .photoEffectProcess = "CIPhotoEffectProcess"
        case .photoEffectNoir = "CIPhotoEffectNoir"
        case .sepiaTone = "CISepiaTone"
        }
    }
    
    var filter: CIFilter {
        return CIFilter(
    }
    
    
    
    static let ColorClamp = "CIColorClamp"
    static let ColorControls = "CIColorControls"
    static let PhotoEffectInstant = "CIPhotoEffectInstant"
    static let PhotoEffectProcess = "CIPhotoEffectProcess"
    static let PhotoEffectNoir = "CIPhotoEffectNoir"
    static let Sepia = "CISepiaTone"
    
    static func defaultFilters() -> [CIFilter] {
        let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        
        let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
        colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
        
        let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
        let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
        let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
        
        let sepia = CIFilter(name: PhotoFilter.Sepia)!
        sepia.setValue(0.7, forKey: kCIInputIntensityKey)
        
        return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
    }

}
