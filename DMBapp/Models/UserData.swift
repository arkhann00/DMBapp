//
//  UserData.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.07.2024.
//

import Foundation

struct UserData:Decodable,Identifiable {
    
    var id:Int
    var name, nickname: String
    var avatarImageName:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nickname
        case avatarImageName = "avatarLink"
    }
}


