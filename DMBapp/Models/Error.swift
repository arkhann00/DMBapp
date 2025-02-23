//
//  Error.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 05.08.2024.
//

import Foundation

struct APIError: Codable, Error {
    var message: String
}
