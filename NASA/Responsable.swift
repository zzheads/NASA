//
//  Responsable.swift
//  NASA
//
//  Created by Alexey Papin on 21.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation

protocol Responsable: JSONDecodable {
    static var nameOfItem: String { get }
    static var nameOfArray: String { get }
}
