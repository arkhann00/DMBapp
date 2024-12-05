//
//  GroupMessage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 18.09.2024.
//

import Foundation

struct GroupMessage: Decodable {
    let participants:[ChatsUser]
    var messages:[Message]
}
