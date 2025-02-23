//
//  HomeNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

protocol HomeNetworkManager {
    func getUserData(completion:@escaping(DataResponse<User,AFError>) -> ())
    func deleteAccount(completion:@escaping(Result<Data?,AFError>) -> ()) async
    func searchUsersWithNickname(nickname:String, completion:@escaping(DataResponse<[UserData], AFError>) -> ()) async
    func fetchSentFriendshipInvitesList(completion:@escaping(Result<[RecieverUser], AFError>) -> ()) async
    func fetchFriendshipInvitesList(completion:@escaping(Result<[SenderUser], AFError>) -> ()) async
    func logOut(completion:@escaping(Result<Data?,AFError>) -> ()) async
    func fetchFriendsList(completion:@escaping(Result<[UserData], AFError>) -> ()) async
    func sendFriendshipInvite(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
    func acceptFriendshipInvite(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func deleteFriend(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func searchUserWithId(id:String, completion:@escaping(DataResponse<UserData, AFError>) -> ()) async
    func getTimer(completion:@escaping(Result<UserTimer,AFError>) -> ())
}
