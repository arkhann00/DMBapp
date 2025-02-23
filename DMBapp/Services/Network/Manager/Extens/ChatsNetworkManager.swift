//
//  ChatsNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire
import UIKit
import AnyCodable

extension NetworkManager: ChatsNetworkManager {
    func deleteMessage(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/messenger/delete-message/\(id)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func editMessage(id: String, text: String, complition: @escaping (DataResponse<Message, AFError>) -> ()) {
        
        let parametrs: Parameters = ["text": text]
        
        AF.request(url.createURL(urlComp: "/messenger/edit-message/\(id)"), method: .put, parameters: parametrs,encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Message.self) { response in
            complition(response)
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
    func sendMessage(id:String, images:[UIImage], text:String, replyToId:String?,completion:@escaping(DataResponse<Message, AFError>) -> ()) {
        AF.upload(multipartFormData: { formData in
            formData.append("\(text)".data(using: String.Encoding.utf8)!, withName: "data")
            formData.append("\(replyToId ?? "")".data(using: String.Encoding.utf8)!, withName: "replyToId")
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
 
    func fetchUnregisteredGlobalChat(lastMessageId:String?, completion:@escaping(DataResponse<[Message],AFError>) -> ()) async {
        let messageId = lastMessageId ?? ""
        AF.request(url.createURL(urlComp: "/messenger/get-global-chat-messages-unregistered?latestMessageId=\(messageId)"), method: .get, encoding: JSONEncoding.default).responseDecodable(of:[Message].self) { response in
            completion(response)
        }
        
    }
    
    func fetchDirectChatData(chatId:String, completion:@escaping(DataResponse<DirectChatData,AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/messenger/direct-chat/\(chatId)"), method: .get, encoding: JSONEncoding.default,headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of:DirectChatData.self) { response in
            completion(response)
        }
        
    }
    
    func banUser(userId:String, complition:@escaping(DataResponse<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/ban-user/\(userId)"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            complition(response)
        }
    }
    
    func unbanUser(userId:String, complition:@escaping(DataResponse<Data?, AFError>) -> ()) {
        AF.request(url.createURL(urlComp: "/user/unban-user/\(userId)"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            complition(response)
        }
    }
    
}
