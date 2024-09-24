//
//  Authorization.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.08.2024.
//

import Foundation

struct Authorization: Codable {
    
    let status:String
    let data:Tokens
}

struct Tokens: Codable {
    let accessToken:String
    let refreshToken:String
    let accessTokenExpiresAt:Int64
    let refreshTokenExpiresAt:Int64
}
