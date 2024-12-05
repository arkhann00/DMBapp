//
//  Settings.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.09.2024.
//

import Foundation

struct Settings: Codable {
    let backgroundImageLink:String?
    let language:String
    let theme:String
    let backgroundTint:Bool
}
