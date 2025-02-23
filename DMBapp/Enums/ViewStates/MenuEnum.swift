//
//  MenuEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.12.2024.
//

import Foundation

enum MenuViewState {
    case none
    case loading
    
    case successLogOut
    case failureLogOut
    
    case successDeleteAccount
    case failureDeleteAccount
    
    case successSaveAvatarImage
    case failureSaveAvatarImage
    
    case successUpdateAvatarImage
    case failureUpdateAvatarImage
    
    case loadingUpdateBackgroundImage
    case successUpdateBackgroundImage
    case failureUpdateBackgroundImage
}
