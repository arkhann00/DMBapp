//
//  SenderUser.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 20.08.2024.
//

import Foundation

struct SenderUser: Decodable, Identifiable {
    let id:String
    let senderId:String
    let senderNickname:String
    let senderAvatarImageName:String?
}
