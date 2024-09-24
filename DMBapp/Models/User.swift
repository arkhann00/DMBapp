//
//  User.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.05.2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let login, name, nickname: String
    let avatarLink: String?
    let userType: String
}
