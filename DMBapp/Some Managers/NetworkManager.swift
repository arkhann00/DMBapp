//
//  NetworkManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.07.2024.
//

import Foundation
import Alamofire
import SwiftUI
import AnyCodable

protocol RegisterNetworkManager {
    func signUp(parametrs:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
    func signIn(parametrs:Parameters, completion:@escaping((DataResponse<Tokens, AFError>) -> ())) async
    func sendOtpCode(parameters:Parameters)
    func mailConfirmation(parametrs:Parameters, completion:@escaping(DataResponse<Tokens, AFError>) -> ()) async
    func fetchSettings(completion:@escaping(DataResponse<Settings, AFError>) -> ()) async
}

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

protocol MessagesNetworkManager {
    func deleteMessage(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func deleteChat(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func updateAllUnreadMessages(id:String) async
    func sendMessage(id:String, images:[UIImage], text:String, completion:@escaping(DataResponse<Message, AFError>) -> ()) 
    func fetchChats(completion:@escaping(DataResponse<[Chat],AFError>) -> ()) async 
    func fetchDirectMessages(id:String, completion:@escaping(DataResponse<FriendMessage,AFError>) -> ()) async
    func fetchGroupMessages(id:String, completion:@escaping(DataResponse<GroupMessage,AFError>) -> ()) async
    func fetchGlobalChats(completion:@escaping(DataResponse<Chat,AFError>) -> ()) async
    func fetchPartMessages(chatId:String, lastMessageId:String?, completion:@escaping(DataResponse<[Message],AFError>) -> ()) async
}

protocol SettingsNetworkManager {
    func updateSettings(parameters:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
    func updateTimer(parametrs:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
}

protocol CalendarNetworkManager {
    func getEvents(completion:@escaping(Result<[EventData], AFError>) -> ())
    func addEvent(parametrs:Parameters, completion:@escaping(Result<EventData, AFError>) -> ()) async
    func deleteEvent(eventId:String, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async
}

class NetworkManager {
    
    private let keychain = KeychainManager.shared
    private let url = UrlLink.remoteServer
    
    private func getHeaders(token:String) -> HTTPHeaders {
        
        var headers:HTTPHeaders {
            var headers:HTTPHeaders = []
            headers.add(name: "Authorization", value: token)
            
            return headers
            
        }
        return headers
        
    }
    
    func updateTokens(completion:@escaping(DataResponse<Tokens,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/refresh-token"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .refreshToken) ?? "")).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    
    func setStatusOnline(completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/set-status-online"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func setStatusOffline(completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/set-status-offline"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    func fetchImage(completion:@escaping(Result<AvatarImage, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/avatar"), headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: AvatarImage.self) { response in
                completion(response.result)
            }
    }
    
    func loadImage(imageURL:String, completion:@escaping(Result<Data, AFError>) -> ()) {
        AF.request(imageURL).responseData { response in
            completion(response.result)
        }
    }

}

// MARK: - RegisterNetworkManager

extension NetworkManager: RegisterNetworkManager {
    func signUp(parametrs:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
        
        
        AF.request(url.createURL(urlComp: "/auth/sign-up"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).validate().response { response in
            completion(response)
            
        }
    }
    
    func signIn(parametrs:Parameters, completion:@escaping((DataResponse<Tokens, AFError>) -> ())) async {
        
        AF.request(url.createURL(urlComp: "/auth/sign-in"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
        
    }
    func sendOtpCode(parameters:Parameters)  {
        AF.request(url.createURL(urlComp: "/auth/send-otp-verification"), method: .post, parameters: parameters, encoding: JSONEncoding.default).response { _ in
            
            print("КОд отправлен")
        }
    }
    func mailConfirmation(parametrs:Parameters, completion:@escaping(DataResponse<Tokens, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/verify-email"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    func fetchSettings(completion:@escaping(DataResponse<Settings, AFError>) -> ())  {
        AF.request(url.createURL(urlComp: "/user/settings"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Settings.self) { response in
            completion(response)
        }
    }
}

// MARK: - HomeNetworkManager

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

// MARK: - MessagesNetworkManager

extension NetworkManager: MessagesNetworkManager {
    func deleteMessage(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/delete-message/\(id)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func deleteChat(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/delete-chat/\(id)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func updateAllUnreadMessages(id:String) async {
        AF.request(url.createURL(urlComp: "/messenger/update-all-unread-messages/\(id)"), method: .post, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            
        }
    }
    func sendMessage(id:String, images:[UIImage], text:String, completion:@escaping(DataResponse<Message, AFError>) -> ()) {
        AF.upload(multipartFormData: { formData in
            formData.append("\(text)".data(using: String.Encoding.utf8)!, withName: "data")
            images.forEach({ image in
                if let imageData = image.jpegData(compressionQuality: 0.7) {
                    formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            })
            
        }, to: url.createURL(urlComp: "/messenger/create/\(id)"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Message.self) { response in
            completion(response)
        }
    }
    
    func fetchChats(completion:@escaping(DataResponse<[Chat],AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/chats"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:[Chat].self) { response in
            completion(response)
        }
    }
    
    func fetchChatsJSON(completion:@escaping(DataResponse<[String : AnyCodable],AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/chats"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:[String : AnyCodable].self) { response in
            completion(response)
        }
    }
    
    func fetchDirectMessages(id:String, completion:@escaping(DataResponse<FriendMessage,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/direct-chat/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:FriendMessage.self) { response in
            completion(response)
        }
    }
    
    func fetchGroupMessages(id:String, completion:@escaping(DataResponse<GroupMessage,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/group-chat/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:GroupMessage.self) { response in
            completion(response)
        }
    }
    func fetchGroupMessagesJSON(id:String, completion:@escaping(DataResponse<[String : AnyCodable],AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/group-chat/\(id)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:[String : AnyCodable].self) { response in
            completion(response)
        }
    }
    
    func fetchPartMessages(chatId:String, lastMessageId:String?, completion:@escaping(DataResponse<[Message],AFError>) -> ()) async {
            let messageId = lastMessageId ?? ""
            AF.request(url.createURL(urlComp: "/messenger/messages/\(chatId)?latestMessageId=\(messageId)"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).validate().responseDecodable(of:[Message].self) { response in
                completion(response)
            }
        
        
        
    }
    
    func fetchGlobalChats(completion:@escaping(DataResponse<Chat,AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/messenger/global-chat"), method: .get, encoding: JSONEncoding.default).responseDecodable(of:Chat.self) { response in
            completion(response)
        }
        
    }
    
    func fetchDirectChatData(chatId:String, completion:@escaping(DataResponse<DirectChatData,AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/messenger/direct-chat/\(chatId)"), method: .get, encoding: JSONEncoding.default,headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:DirectChatData.self) { response in
            completion(response)
        }
        
    }
    
}

// MARK: - EventNetworkManager

extension NetworkManager: CalendarNetworkManager {
    func getEvents(completion:@escaping(Result<[EventData], AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/event"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [EventData].self) { response in
            completion(response.result)
        }
        
    }
    
    func addEvent(parametrs:Parameters, completion:@escaping(Result<EventData, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/event"), method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: EventData.self) { response in
            completion(response.result)
        }
        
    }
    
    func deleteEvent(eventId:String, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/event/\(eventId)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
        
    }
}

// MARK: - SettingsNetworkManager
    
extension NetworkManager: SettingsNetworkManager {
    func updateSettings(parameters:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/user/settings"),method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
        
    }
    func updateTimer(parametrs:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/timer"), method: .put, parameters:parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response{ response in
            completion(response)
        }
    }
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
       
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/background-image"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
    }
}

protocol AvatarPickerNetworkManager {
    func updateAvatarImage(image:UIImage, completion:@escaping(Result<Data?,AFError>) -> ())
}

extension NetworkManager: AvatarPickerNetworkManager {
    func updateAvatarImage(image: UIImage, completion: @escaping (Result<Data?, Alamofire.AFError>) -> ()) {
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
