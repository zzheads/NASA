//
//  MarsRoverError.swift
//  NASA
//
//  Created by Alexey Papin on 26.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

enum MarsRoverError: Error {
    case loadingManifest(String, Error)
    case nothingToSave
    case savingError(Error)
    case noInfo
    case loadingImages(String, Error?)
    
    static let title = "Mars Rover Error"
    
    var message: String {
        switch self {
        case .loadingManifest(let rover, let error): return "Loading Rover \(rover) Manifest error: \(error)"
        case .nothingToSave: return "There is nothing to save"
        case .savingError(let error): return "Can not save an image, error: \(error)"
        case .noInfo: return "Can not load images: insufficient information, you have to choose rover and sol"
        case .loadingImages(let rover, let error):
            if let error = error as? NSError {
                if let failureReason = error.localizedFailureReason {
                    return "Loading images for \(rover) rover error: \(failureReason)"
                } else {
                    return "Loading images for \(rover) rover error: \(error.localizedDescription)"
                }
            } else {
                return "Unknown error loading images for \(rover) rover"
            }
        }
    }
}
