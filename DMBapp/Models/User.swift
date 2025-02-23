//
//  User.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.05.2024.
//

import Foundation
import SwiftUI

struct User: Decodable {
    let id: String
    let nickname: String
    let login: String
    let avatarLink: String?
    let userType: String
    let isAdmin: Bool
}
