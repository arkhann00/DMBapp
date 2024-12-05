//
//  RecieverUser.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 20.08.2024.
//

import Foundation

struct RecieverUser: Decodable {
    let id:String
    let recieverId:String
    let recieverNickname:String
    let recieverrAvatarImageName:String?
}
