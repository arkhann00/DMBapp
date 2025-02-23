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


class ChatsViewModel: ViewModel {
    
    private var socket: WebSocket!
    
    @Published var viewState:MessageViewState = .none
    @Published var users:[UserData] = []
    @Published var friendMessages:FriendMessage?
    @Published var chats:[Chat] = []
    @Published var globalChat:Chat?
    @Published var messages:[Message] = []
    private var bufferMessages:[[Message]] = []
    @Published var loadingMessages:[LoadingMessage] = []
    @Published var fetchMessagesStatus:Bool = true
    @Published var lastMessageId:String?
    @Published var countOfImages = 0
    
    override init() {
        super.init()
        self.connect()
    }
    
    func isAdmin() -> Bool {
        return userDefaults.bool(forKey: .isAdminUser) ?? false
    }
    
    func fetchImage(imageLink:String, completion:@escaping(Image) -> ()) {
        networkManager.loadImage(imageURL: imageLink) { result in
            switch result {
            case .success(let data):
                guard let uiImage = UIImage(data: data) else { return }
                let image = Image(uiImage: uiImage)
                completion(image)
            case .failure(_):
                print("error fetch image")
            }
        }
    }
    
    func banUser(userId:String) {
        print(userId)
        networkManager.banUser(userId: userId) { response in
            switch response.result {
            case .success(_):
                print("SUCCESS BAN USER")
            case .failure(_):
                print("ERROR BAN USER: \(response)")
            }
        }
        
    }
    
    func unbanUser(userId:String) {
        networkManager.unbanUser(userId: userId) { response in
            switch response.result {
            case .success(_):
                print("SUCCESS UNBAN USER")
            case .failure(_):
                print("ERROR UNBAN USER: \(response)")
            }
        }
    }
    
    @MainActor
    func fetchGlobalChat() async {
        if globalChat == nil {
            viewState = .loading
        }
        await networkManager.fetchGlobalChats { [weak self] response in
            switch response.result {
            case .success(let chat):
                self?.globalChat = chat
                print("SUCCESS FETCH GLOBAL CHAT")
            case .failure(_):
                response.printJsonError()
            }
        }
    }
    
    
        
    @MainActor
    func fetchChats() async {
        if chats.isEmpty {
            viewState = .loading
        }
        await networkManager.fetchChats { [weak self] response in
            switch response.result {
            case .success(let chats):
                self?.viewState = .successFetchChats
                self?.chats = chats
                print("SUCCESS FETCH CHATS")
            case .failure(_):
                self?.viewState = .failureFetchChats
                print("ERROR CHAT LIST:\(response)")
            }
        }
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    @MainActor
    func searchUserWithName(name:String) async {
        Task {
            await networkManager.searchUsersWithNickname(nickname: name) { [weak self] response in
                switch response.result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    print("ERROR SEARCHUSERS:\(error.localizedDescription)")
                }
            }
        }
    }
    
    @MainActor
    func fetchUnregisteredGlobalChat() async {
        if globalChat == nil {
            viewState = .loading
        }
        
        let lastMessageId = messages.first?.id
        
        await networkManager.fetchUnregisteredGlobalChat(lastMessageId: lastMessageId) { [weak self] response in
            switch response.result {
            case .success(let messages):
                if messages.count == 0  {
                    self?.fetchMessagesStatus = false
                    self?.viewState = .failureFetchMorePartOfMessages
                } else if lastMessageId == nil {
                    self?.messages = messages
                    self?.viewState = .successFetchFirstPartOfMessages
                } else {
                    let oldMessages = self?.messages ?? []
                    self?.messages = messages + oldMessages
                    self?.viewState = .successFetchMorePartOfMessages
                }
                print("SUCCESS fetchUnregisteredGlobalChat")
            case .failure(_):
                response.printJsonError()
                print("FAILURE fetchUnregisteredGlobalChat:\(response)")
            }
        }
    }
      
    @MainActor
    func fetchPartOfMessages(chatId:String) async {
                
        viewState = .loading
                
        let lastMessageId = messages.first?.id
        
        guard fetchMessagesStatus else {
            viewState = .failureFetchMorePartOfMessages
            return
        }
        
        self.lastMessageId = messages.first?.id

        await networkManager.fetchPartMessages(chatId: chatId, lastMessageId: lastMessageId) { [weak self] response in
            switch response.result {
            case .success(let messages):
                
                if messages.count == 0  {
                    self?.fetchMessagesStatus = false
                    self?.viewState = .failureFetchMorePartOfMessages
                } else if lastMessageId == nil {
                    self?.messages = messages
                    self?.viewState = .successFetchFirstPartOfMessages
                } else {
                    let oldMessages = self?.messages ?? []
                    self?.messages = messages + oldMessages
                    self?.viewState = .successFetchMorePartOfMessages
                }
                
                print("SUCCESS FETCH PART MESSAGES")
                
            case .failure(_):
                print("ERROR")
                if lastMessageId == nil {
                    self?.viewState = .failureFetchFirstPartOfMessages
                } else {
                    self?.viewState = .failureFetchMorePartOfMessages
                }
                response.printJsonError()
                print(response)
                
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
    
    func sendMessage(id:String, text:String, images:[UIImage], replyToId:String?) {
    
        loadingMessages.append(LoadingMessage(text: text, image: images))
        networkManager.sendMessage(id: id, images: images, text: text, replyToId: replyToId) {[weak self] response in
            switch response.result {
            case .success(let message):
                self?.loadingMessages.removeAll()
                self?.messages.append(message)
                self?.viewState = .successSentMessage
                print("SUCCESS SEND MESSAGE")
            case .failure(let error):
                self?.viewState = .failureSentMessage
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
    
    @MainActor
    func removeMessage(messageId:String, chatId:String) async {
        await networkManager.deleteMessage(id: messageId) {[weak self] result in
            switch result {
            case .success(_):
//                self?.fetchPartMessages(chatId: chatId, lastMessageId: nil)
                self?.removeMessegeWithId(id: messageId)
                print("SUCCESS REMOVE MESSAGE")
            case .failure(_):
                print("ERROR REMOVE MESSAGE")
            }
        }
    }
    private func removeMessegeWithId(id:String) {
        for i in 0 ..< messages.count {
            if messages[i].id == id {
                messages.remove(at: i)
                return
            }
        }
    }
    
    func editMessage(messageId:String, text:String) {
        
        
        
        networkManager.editMessage(id: messageId, text: text) { [weak self] response in
            switch response.result {
            case .success(_):
                self?.viewState = .successEditMessage
                print("SUCCESS EDIT MESSAGE")
                
            case .failure(_):
                self?.viewState = .failureEditMessage
                print("FAILURE EDIT MESSAGE: \(response)")
            }
        }
    }
    
    func readAllMessages(chatId:String) async{
        await networkManager.updateAllUnreadMessages(id: chatId)
        await fetchChats()
    }
    
    func removeChat(chatId:String) async {
        await networkManager.deleteChat(id: chatId) { result in
            switch result {
            case .success(_):
                print("SUCCESS DELETE CHAT")
            case .failure(_):
                print("FAILURE DELETE CHAT")
            }
        }
        await fetchChats()
    }
    
}

extension ChatsViewModel: WebSocketDelegate {
    
    func connect() {
        let url = WebSocketLink.testServer
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
                    messages.append(model.data)
                    
                    print(1)
                case "message_edited":
                    print("message_edited")
                case "message_deleted":
                    
                    print(2)
                case "all_messages_read":
//                    fetchPartMessages(chatId: model.data.chatId, lastMessageId: nil)
                    
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
