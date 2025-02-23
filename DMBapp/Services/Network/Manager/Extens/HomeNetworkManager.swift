//
//  HomeNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire
import UIKit

extension NetworkManager: HomeNetworkManager {
    func getUserData(completion:@escaping(DataResponse<User,AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/user/"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).validate().responseDecodable(of:User.self) { response in
            completion(response)
        }
        
    }
    
    func deleteAccount(completion:@escaping(Result<Data?,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func fetchSentFriendshipInvitesList(completion:@escaping(Result<[RecieverUser], AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/sent-requests"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [RecieverUser].self) { response in
            completion(response.result)
        }
    }
    func searchUsersWithNickname(nickname:String, completion:@escaping(DataResponse<[UserData], AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/nickname/\(nickname)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:[UserData].self) { response in
            completion(response)
        }
    }
    func fetchFriendshipInvitesList(completion:@escaping(Result<[SenderUser], AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/recieved-requests"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [SenderUser].self) { response in
            completion(response.result)
        }
    }
    
    func logOut(completion:@escaping(Result<Data?,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/log-out"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func fetchFriendsList(completion:@escaping(Result<[UserData], AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/friends"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [UserData].self) { response in
            completion(response.result)
        }
    }
    
    
    
    func sendFriendshipInvite(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/send-request/\(personId)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func acceptFriendshipInvite(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/accept-request/\(personId)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func deleteFriend(personId:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/friendship/\(personId)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func searchUserWithId(id:String, completion:@escaping(DataResponse<UserData, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/id/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:UserData.self) { response in
            completion(response)
        }
    }
    
    func updateAvatarImage(image:UIImage, completion:@escaping(Result<Data?,AFError>) -> ()) async {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Ошибка конвертации изображения")
            return
        }
        
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/avatar"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
        
    }
    
    func getTimer(completion:@escaping(Result<UserTimer,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/timer"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).validate().responseDecodable(of: UserTimer.self) { response in
            completion(response.result)
        }
        
    }
    
    func deleteBackgroundImage(completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/background-image"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
    }
    
    func deleteAvatarImage(completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/avatar"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
    }
    
}
