//
//  MessageViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.07.2024.
//

import Foundation
import Combine
import SwiftUI
import Starscream

class MessageViewModel:ObservableObject {
    
    private let networkManager = NetworkManager.shared
    private let userDefaults = UserDefaultsManager.shared
    private let keychain = KeychainManager.shared
    private var socket: WebSocket!
    
    private var user:User?
    @Published var viewState:ViewState = .none
    @Published var searchedText = ""
    @Published var users:[UserData] = []
    @Published var friends:[UserData] = []
    @Published var chats:[Chat] = []
    @Published var globalChat:Chat?
    @Published var messages:[Message] = []
    @Published var oldMessages:[Message] = []
    @Published var loadingMessages:[LoadingMessage] = []
    
    init() {
        fetchFriends()
        fetchChats()
        connect()
    }
    
    func fetchUser() {
        
        networkManager.getUserData { [weak self] response in
            let result = response.result
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(_):
                
                if let id = self?.userDefaults.integer(forKey: .userId), let login = self?.userDefaults.string(forKey: .userLogin), let name = self?.userDefaults.string(forKey: .userName), let nickname = self?.userDefaults.string(forKey: .userNickname), let userType = self?.userDefaults.string(forKey: .userType) {
                    
                    self?.user = User(id: id, login: login, name: name, nickname: nickname, avatarLink: self?.userDefaults.string(forKey: .userAvatarImage), userType: userType)
                }
                
                print("FAILURE FETCH USER:\(response)")
                if let data = response.data {
                    do {
                        let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                        print("USER ERROR: \(networkError.message)")
                    } catch {
                        print("")
                    }
                }
            }
        }
        
    }
    
    func isAuthorizedUser() -> Bool {
        if let _ = keychain.load(key: .refreshToken) {
            return true
        }
        
        return false
    }
    
    func fetchMessanges(chatId:Int) {
        networkManager.fetchDirectMessages(id: chatId) {[weak self] response in
            switch response.result {
            case .success(let messages):
                self?.friendMessages = messages
            case .failure(_):
                print("ERROR FETCH MESSANDES: \(response)")
            }
        }
        
    }
    
    func fetchImage(imageLink:String, completion:@escaping(Image) -> ()) {
        networkManager.loadImage(imageURL: imageLink) { result in
            switch result {
            case .success(let data):
                let image = Image(uiImage: UIImage(data: data)!)
                completion(image)
            case .failure(_):
                print("error fetch image")
            }
        }
    }
    
    func fetchChats() {
        viewState = .loading
        networkManager.fetchMessagerList {[weak self] response in
            switch response.result {
            case .success(let chats):
                self?.viewState = .online
                self?.chats = chats
                print("SUCCESS FETCH CHATS")
            case .failure(_):
                self?.viewState = .offline
                print("ERROR CHAT LIST:\(response)")
            }
        }
    }
    
    func fetchFriends() {
        networkManager.fetchFriendsList {[weak self] result in
            switch result {
            case .success(let friends):
                print("SUCCESS FETCH FRIENDS")
                self?.friends.removeAll()
                self?.friends = friends
            case .failure(let error):
                print(123)
                print("ERROR FETCH FRIENDS:\(error.localizedDescription)")
            }
        }
    }
    
    func fetchGroupMessages(chatId:Int) {
        networkManager.fetchGroupMessages(id: chatId) {[weak self] response in
            switch response.result {
            case.success(let groupMessages):
                self?.groupMessages = groupMessages
            case .failure(_):
                print("ERROR GROUP MESSAGES:\(response)")
            }
        }
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    func searchUserWithName(name:String) {
        networkManager.searchUsersWithName(name: name) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.deleteCurrentUser()
            case .failure(let error):
                print("ERROR SEARCHUSERS:\(error.localizedDescription)")
            }
        }
    }
    
    private func deleteCurrentUser() {
        guard let currentUser = user else { return }
        for i in 0 ..< users.count {
            if users[i].id == currentUser.id {
                users.remove(at: i)
            }
        }
    }
    
    func getBackgroundImage() -> Image {
        
        guard let defaultData = UIImage(named: "MainBackground")?.pngData() else { return Image("MainBackground") }
        
        let backgroundUIImaage = UIImage(data: userDefaults.data(forKey: .backgroundImage) ?? defaultData)
        
        return Image(uiImage: backgroundUIImaage!)
        
    }
    
    func getIsDimBackground() -> Bool {
        return userDefaults.bool(forKey: .isBackgroundDim) ?? false
    }
    
    func sendMessage(id:Int, text:String, images:[UIImage]) {
        
//        friendMessages?.messages.insert(Message(id: -1, chatId: -1, senderId: -1, senderName: "", senderAvatarLink: "", text: text, attachmentLinks: [], creationDate: "", creationTime: "", isRead: false, isEdited: false, isSender: true), at: 0)
//        groupMessages?.messages.insert(Message(id: id, chatId: id, senderId: -1, senderName: "", senderAvatarLink: "", text: text, attachmentLinks: [], creationDate: "", creationTime: "", isRead: false, isEdited: false, isSender: true), at: 0)
        
        networkManager.sendFriendMessage(id: id, images: images, text: text) {[weak self] response in
            switch response.result {
            case .success(let message):
                self?.fetchMessanges(chatId: message.chatId)
                self?.fetchGroupMessages(chatId: message.chatId)
                print("SUCCESS SEND MESSAGE")
            case .failure(let error):
                print("FAILURE SEND MESSAGE: \(error.localizedDescription)")
                if let data = response.data {
                    do {
                        let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                        print(networkError.message)
                    } catch {
                        do {
                            let networkError = try JSONDecoder().decode(String.self, from: data)
                            print(networkError)
                        } catch {
                            print(response)
                        }
                    }
                }
            }
        }
    }
    
    func removeMessage(messageId:Int, chatId:Int) {
        networkManager.deleteMessage(id: messageId) {[weak self] result in
            switch result {
            case .success(_):
                self?.fetchMessanges(chatId: chatId)
                print("SUCCESS REMOVE MESSAGE")
            case .failure(_):
                print("ERROR REMOVE MESSAGE")
            }
        }
    }
    
    func readAllMessages(chatId:Int) {
        networkManager.updateAllUnreadMessages(id: chatId)
        fetchChats()
    }
    
    func removeChat(chatId:Int) {
        networkManager.deleteChat(id: chatId) {[weak self] result in
            switch result {
            case .success(_):
                self?.fetchChats()
                print("SUCCESS DELETE CHAT")
            case .failure(_):
                print("FAILURE DELETE CHAT")
            }
        }
    }
    
}

extension MessageViewModel: WebSocketDelegate {
    
    func connect() {
        let url = WebSocketLink.localhost
        var request = URLRequest(url: URL(string: url.createURL(urlComp: (keychain.load(key: .accessToken) ?? "") ))!)
        request.timeoutInterval = 20
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }

    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("Connected: \(headers)")
            
        case .disconnected(let reason, let code):
            print("Disconnected: \(reason) with code: \(code)")
            
        case .text(let string):
            handleReceivedText(string)
            
        case .binary(let data):
            handleReceivedData(data)
            
        case .ping(_):
            break
            
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(_):
            break
        case .peerClosed:
            break
        }
    }

    private func handleReceivedText(_ text: String) {
        if let data = text.data(using: .utf8) {
            decodeReceivedData(data)
        }
    }

    private func handleReceivedData(_ data: Data) {
        decodeReceivedData(data)
    }
    private func decodeReceivedData(_ data: Data) {
        do {
            let model = try JSONDecoder().decode(SocketMessage.self, from: data)
            DispatchQueue.main.async { [self] in
                
                print(model.data)
                switch model.name {
                case "message_sent":
                    
                    friendMessages?.messages.append(model.data)
                    groupMessages?.messages.append(model.data)
                    fetchChats()
                    
                    print(1)
                case "message_edited":
                    print("message_edited")
                case "message_deleted":
                    fetchMessanges(chatId: model.data.chatId)
                    fetchGroupMessages(chatId: model.data.chatId)
                    fetchChats()
                    print(2)
                case "all_messages_read":
                    fetchMessanges(chatId: model.data.chatId)
                    fetchGroupMessages(chatId: model.data.chatId)
                    fetchChats()
                    print(3)
                    
                default:
                    print("SOCKET ERROR")
                }
            }
        } catch {
            print("Failed to decode JSON IN WEBSOCKET: \(error)")
        }
    }
    
}
