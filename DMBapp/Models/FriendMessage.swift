//
//  Message.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.08.2024.
//

import Foundation

struct FriendMessage: Decodable {
    let companion:ChatsUser
    var messages:[Message]
}

struct ChatsUser: Decodable {
    let id:String
    let nickname:String
    let avatarLink:String?
}

struct Message: Decodable, Identifiable, Hashable {
    let id:String
    let chatId:String
    let senderId: String
    let senderNickname: String
    let senderAvatarLink: String?
    let text: String
    let attachmentLinks: [String]
    let creationDate: String
    let creationTime: String
    let isRead: Bool
    let isEdited: Bool
    let isSender: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "messageId"
        case chatId
        case senderId
        case senderNickname
        case senderAvatarLink
        case text
        case attachmentLinks
        case creationDate
        case creationTime
        case isRead
        case isEdited
        case isSender
    }
}
