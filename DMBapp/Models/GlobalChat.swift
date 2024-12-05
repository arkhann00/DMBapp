//
//  GlobalChat.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.09.2024.
//

import Foundation

struct GlobalChat:Decodable {
    
    let chatId: String
    let name: String
    let imageLink: String?
    let lastMessageText: String?
    let lastMessageCreationTime: String?
    let lastMessageSenderName: String?
    let unreadMessagesAmount: Int?
    let isGroupChat: Bool
    let isOnline: Bool
    
}
