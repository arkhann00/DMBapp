//
//  SenderUser.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 20.08.2024.
//

import Foundation

struct SenderUser: Decodable, Identifiable {
    let id:Int
    let senderId:Int
    let senderName:String
    let senderNickname:String
    let senderAvatarImageName:String?
}
