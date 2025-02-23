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
    private let webSocket = WebSocketManager()
    private var socket: WebSocket!
    
    private var user:User?
    @Published var searchedText = ""
    @Published var users:[UserData] = []
    @Published var friends:[UserData] = []
    @Published var chats:[Chat] = []
    @Published var messages:[Message] = []
    
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
    
    
    func fetchMessanges(chatId:Int) {
        networkManager.fetchMessages(id: chatId) {[weak self] response in
            switch response.result {
            case .success(let messages):
                self?.messages = messages
                
            case .failure(_):
                print("ERROR FETCH MESSANDES")
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
        networkManager.fetchMessagerList {[weak self] response in
            switch response.result {
            case .success(let chats):
                self?.chats = chats
            case .failure(_):
                print("ERROR CHAT LIST")
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
                print("ERROR FETCH FRIENDS:\(error.localizedDescription)")
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
        
        networkManager.sendMessage(id: id, images: images, text: text) {[weak self] response in
            switch response.result {
            case .success(let message):
                self?.fetchMessanges(chatId: id)
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
                guard let chatId = model.data["chatId"]?.value as? Int else { return }
                switch model.name {
                case "message_sent":
                    fetchMessanges(chatId: chatId)
                    fetchChats()
                    readAllMessages(chatId: chatId)
                case "message_edited":
                    print("message_edited")
                case "message_deleted":
                    fetchMessanges(chatId: chatId)
                    fetchChats()
                case "all_messages_read":
                    fetchMessanges(chatId: chatId)
                    fetchChats()
                    break
                default:
                    print("SOCKET ERROR")
                }
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
}
