//
//  APODError.swift
//  NASA
//
//  Created by Alexey Papin on 26.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

enum APODError: Error {
    case badPath(String)
    case unknownMedia(String)
    case nothingToSave
    case saveUnknownMedia(String)
    case incorrectDate
    case savingError(Error)
    
    static let title: String = "APOD Error"
    
    var message: String {
        switch self {
        case .badPath(let path): return "Can not make url with path: \(path)"
        case .unknownMedia(let media): return "Format of media is unknown: \(media)"
        case .nothingToSave: return "There is nothing to save"
        case .saveUnknownMedia(let media): return "Can not save \(media) media to photo library"
        case .incorrectDate: return "You've choosen incorrect date, there is no APOD's for future dates, please select date before or equal today"
        case .savingError(let error): return "Can not save an image, error: \(error)"
        }
    }
}
