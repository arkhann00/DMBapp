//
//  UserData.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.07.2024.
//

import Foundation

struct UserData:Decodable,Identifiable {
    
    let id:String
    let nickname: String
    let avatarLink:String?
    let isFriend: Bool
    let isFriendshipRequestSent: Bool
    let isFriendshipRequestRecieved:Bool
    
}
