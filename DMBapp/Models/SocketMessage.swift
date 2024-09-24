//
//  SocketMessage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 04.09.2024.
//

import Foundation
import AnyCodable

struct SocketMessage: Decodable {
    let type:String
    let name:String
    let data:Message
}
