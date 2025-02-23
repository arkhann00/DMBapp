//
//  Message.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.08.2024.
//

import Foundation

struct Message: Decodable, Identifiable, Hashable {
    
    let id:Int
    let chatId:Int
    let senderId: Int
    let senderName: String
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
        case senderName
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
