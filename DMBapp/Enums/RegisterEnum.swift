//
//  RegisterEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 21.09.2024.
//

import Foundation

enum RegisterViewEnum {
    
    case none
    case loading
    
    case successReg
    case nicknameIsTaken
    case invalidInputFormat
    case accountAlreadyExists
    case failureReg
    
    case successAuth
    case incorrectPassword
    case dataNotFound
    case failureAuth
    
}
