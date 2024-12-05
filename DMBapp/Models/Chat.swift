//
//  Chat.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 04.09.2024.
//

import Foundation

struct Chat: Decodable {
    let chatId: String
    let name: String
    let imageLink: String?
    let lastMessageText: String?
    let lastMessageCreationTime: String?
    let lastMessageSenderName: String?
    let unreadMessagesAmount: Int?
    let chatType: String
    let isOnline: Bool
}
