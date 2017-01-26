//
//  LandsatError.swift
//  NASA
//
//  Created by Alexey Papin on 26.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

enum LandsatError: Error {
    static let title = "Landsat Error"
    
    case loadingAsset(String, Error)
    case loadingImage(Error?)
    case noInfo
    case savingImage(Error?)
    case nothingToSave
    
    var message: String {
        switch self {
        case .loadingAsset(let location, let error): return "Loading asset for \(location) error: \(error)"
        case .loadingImage(let error):
            if let error = error {
                return "Loading Landsat image error: \(error)"
            } else {
                return "Unknown loading Landsat Image error"
            }
        case .noInfo: return "Can not load image, DO NOT get any location and date"
        case .savingImage(let error):
            if let error = error {
                return "Saving Landsat image error: \(error)"
            } else {
                return "Unknown saving Landsat Image error"
            }
        case .nothingToSave: return "There is nothing to save"
        }
    }
}
