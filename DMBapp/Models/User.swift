//
//  User.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.05.2024.
//

import Foundation

struct User: Codable {
    let id: String
    let login, nickname: String
    let avatarLink: String?
    let userType: String
}
