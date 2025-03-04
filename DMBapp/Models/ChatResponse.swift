//
//  ChatResponse.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.09.2024.
//

import Foundation

struct ChatResponse: Decodable {
    var globalChat: Chat
    var chats:[Chat]
}

