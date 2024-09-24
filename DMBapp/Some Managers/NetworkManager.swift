//
//  NetworkManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.07.2024.
//

import Foundation
import Alamofire
import SwiftUI
import AVKit
import ImageIO
import MobileCoreServices

class NetworkManager {
    
    static let shared = NetworkManager()
    private let keychain = KeychainManager.shared
    
    let url = UrlLink.localhost
    
    private init() {}
    
//    private func getToken(completion:@escaping(String) -> ()) {
//        if let accessToken = keychain.load(key: .accessToken), let accessTime = UInt64(keychain.load(key: .accessTime)!), let refreshToken = keychain.load(key: .refreshToken), let refreshTime = UInt64(keychain.load(key: .refreshTime)!) {
//            
//            if UInt64(Date.now.timeIntervalSince1970) - accessTime < 1800 {
//                completion(accessToken)
//            }
//            else {
//                if UInt64(Date.now.timeIntervalSince1970) - refreshTime < 2592000 {
//                    completion(refreshToken)
//                }
//            }
//            
//        }
//        completion("")
//    }
    
    
    
    private func getHeaders(token:String) -> HTTPHeaders {
        
        
        var headers:HTTPHeaders {
            var headers:HTTPHeaders = []
            headers.add(name: "Authorization", value: token)
            
            return headers
            
        }
        return headers
        
    }
    
    func updateTokens(completion:@escaping(DataResponse<Tokens,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/auth/refresh-token"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .refreshToken) ?? "")).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    
    func signUp(parametrs:[String : String], completion:@escaping(DataResponse<Tokens,AFError>) -> ()) {
        
        
        AF.request(url.createURL(urlComp: "/auth/sign-up"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).validate().responseDecodable { response in
            completion(response)
            
        }
    }
    
    func signIn(parametrs:[String : String], completion:@escaping((DataResponse<Authorization, AFError>) -> ())) {
        
        AF.request(url.createURL(urlComp: "/auth/sign-in"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Authorization.self) { response in
            completion(response)
        }
        
    }
    
    func getTimer(completion:@escaping(Result<UserTimer,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/timer"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).validate().responseDecodable(of: UserTimer.self) { response in
            completion(response.result)
        }
        
    }
    
    func setStatusOnline(completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/set-status-online"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func mailConfirmation(parametrs:Parameters, completion:@escaping(DataResponse<Tokens, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/auth/verify-email"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    
    func setStatusOffline(completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/set-status-offline"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
        
    }
    
    func updateTimer(parametrs:Parameters, completion:@escaping(DataResponse<UserTimer, AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/timer"), method: .put, parameters:parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: UserTimer.self) { response in
            completion(response)
        }
    }
    
    func getUserData(completion:@escaping(DataResponse<User,AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/user/"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).validate().responseDecodable(of:User.self) { response in
            completion(response)
        }
        
    }
    
    func getEvents(completion:@escaping(Result<[EventData], AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/event"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [EventData].self) { response in
            completion(response.result)
        }
        
    }
    
    func addEvent(parametrs:[String : Any], completion:@escaping(Result<Data?, AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/event"), method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
        
    }
    
    func deleteEvent(eventId:Int, completion:@escaping(DataResponse<EventData, AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/event/\(eventId)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: EventData.self) { response in
            completion(response)
        }
        
    }
    
    func fetchSettings(completion:@escaping(DataResponse<Settings, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/settings"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Settings.self) { response in
            completion(response)
        }
    }
    
    func updateSettings(parameters:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/user/settings"),method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
        
    }
    
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) {
       
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/background-image"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
    }
    
    
    
    func deleteAccount(completion:@escaping(Result<Data?,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/auth/"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func logOut(completion:@escaping(Result<Data?,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/auth/log-out"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func fetchFriendsList(completion:@escaping(Result<[UserData], AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/friends"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [UserData].self) { response in
            completion(response.result)
        }
    }
    
    
    
    func sendFriendshipInvite(personId:Int, completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/send-request/\(personId)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func acceptFriendshipInvite(personId:Int, completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/accept-request/\(personId)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func deleteFriend(personId:Int, completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/\(personId)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func updateImage(image:UIImage, completion:@escaping(Result<Data?,AFError>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Ошибка конвертации изображения")
            return
        }
        
        let headers:HTTPHeaders = [
            "Content-type" : "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/avatar"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
        
    }
    
    func searchUsersWithName(name:String, completion:@escaping(Result<[UserData], AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/name/\(name)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:[UserData].self) { response in
            completion(response.result)
        }
    }
    
    func fetchSentFriendshipInvitesList(completion:@escaping(Result<[RecieverUser], AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/sent-requests"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [RecieverUser].self) { response in
            completion(response.result)
        }
    }
    func fetchFriendshipInvitesList(completion:@escaping(Result<[SenderUser], AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/friendship/recieved-requests"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [SenderUser].self) { response in
            completion(response.result)
        }
    }
    
    func sendFriendMessage(id:Int, images:[UIImage], text:String, completion:@escaping(DataResponse<Message, AFError>) -> ()) {
        AF.upload(multipartFormData: { formData in
            formData.append("\(text)".data(using: String.Encoding.utf8)!, withName: "data")
            images.forEach({ image in
                if let imageData = image.heic() {
                    formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            })
            
        }, to: url.createURL(urlComp: "/messenger/create/\(id)"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Message.self) { response in
            completion(response)
        }
        
        
    }
    
    func fetchMessagerList(completion:@escaping(DataResponse<ChatResponse,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/messenger/chats"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:ChatResponse.self) { response in
            completion(response)
        }
    }
    
    func fetchDirectMessages(id:Int, completion:@escaping(DataResponse<FriendMessage,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/messenger/direct-chat/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:FriendMessage.self) { response in
            completion(response)
        }
    }
    
    func fetchGroupMessages(id:Int, completion:@escaping(DataResponse<GroupMessage,AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/messenger/group-chat/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:GroupMessage.self) { response in
            completion(response)
        }
    }
    
    func fetchImage(completion:@escaping(Result<ImageModel, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/avatar"), headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: ImageModel.self) { response in
                completion(response.result)
            }
    }
    
    
    func loadImage(imageURL:String, completion:@escaping(Result<Data, AFError>) -> ()) {
        AF.request(imageURL).responseData { response in
            completion(response.result)
        }
    }

    func deleteMessage(id:Int, completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/messenger/delete-message/\(id)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func deleteChat(id:Int, completion:@escaping(Result<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/messenger/delete-chat/\(id)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func updateAllUnreadMessages(id:Int) {
        AF.request(url.createURL(urlComp: "/messenger/update-all-unread-messages/\(id)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            
        }
    }

}


    
    


    
enum UrlLink {
    
    case localhost
    case remoteServer
    
    func createURL(urlComp:String) -> String {
        switch self {
        case .localhost:
            return "http://127.0.0.1:3000" + urlComp
        case .remoteServer:
            return "https://duty-timer.sunfesty.ru" + urlComp
        }
    }
    
}
