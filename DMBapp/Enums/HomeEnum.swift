//
//  HomeEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.09.2024.
//

import Foundation

enum HomeViewState {
    
    case none
    case loading
    
    // fetchTimer
    case successFetchTimer
    case failureFetchTimer
    
    // acceptFriendshipInvite
    case successAcceptFriendshipInvite
    case failureAcceptFriendshipInvite
    
    // deleteFromFriends
    case successDeleteFromFriends
    case failureDeleteFromFriends
    
    // fetchFriends
    case successFetchFriends
    case failureFetchFriends
    
    // fetchFriendshipInvites
    case successFetchFriendshipInvites
    case failureFetchFriendshipInvites
    
    // searchUserWithName
    case successSearchUserWithName
    case failureSearchUserWithName
    
    // updateAvatarImage
    case successUpdateAvatarImage
    case failureUpdateAvatarImage
    
    case successSendFriendshipInvite
    case failureSendFriendshipInvite
    
}
