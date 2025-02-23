//
//  ChatsNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire
import UIKit

protocol ChatsNetworkManager {
    func deleteMessage(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func deleteChat(id:String, completion:@escaping(Result<Data?, AFError>) -> ()) async
    func updateAllUnreadMessages(id:String) async
    func sendMessage(id:String, images:[UIImage], text:String, replyToId:String?,completion:@escaping(DataResponse<Message, AFError>) -> ())
    func editMessage(id:String, text:String, complition:@escaping(DataResponse<Message,AFError>) -> ())
    func fetchChats(completion:@escaping(DataResponse<[Chat],AFError>) -> ()) async
    func fetchDirectMessages(id:String, completion:@escaping(DataResponse<FriendMessage,AFError>) -> ()) async
    func fetchGroupMessages(id:String, completion:@escaping(DataResponse<GroupMessage,AFError>) -> ()) async
    func fetchGlobalChats(completion:@escaping(DataResponse<Chat,AFError>) -> ()) async
    func fetchPartMessages(chatId:String, lastMessageId:String?, completion:@escaping(DataResponse<[Message],AFError>) -> ()) async
}
