//
//  WebSocketManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 07.08.2024.
//

import Foundation
import Alamofire
import Starscream

class WebSocketManager: ObservableObject, WebSocketDelegate {
    
    private let url:WebSocketLink = .localhost
    private var keychain = KeychainManager.shared
    private var socket: WebSocket!
    @Published var receivedMessage:Int?

    @Published var isConnected: Bool = false

    init() {
        connect()
    }

    func connect() {
        var request = URLRequest(url: URL(string: url.createURL(urlComp: (keychain.load(key: .accessToken) ?? "") ))!)
        request.timeoutInterval = 2
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
            isConnected = true
            
        case .disconnected(let reason, let code):
            print("Disconnected: \(reason) with code: \(code)")
            isConnected = false
            
        case .text(let string):
            handleReceivedText(string)
            
        case .binary(let data):
            print("Received data: \(data.count) bytes")
            handleReceivedData(data)
            
        case .ping(_):
            print("Ping")
            
        case .pong(_):
            print("Pong")
            
        case .viabilityChanged(let isViable):
            print("Viability changed: \(isViable)")
            
        case .reconnectSuggested(let shouldReconnect):
            print("Reconnect suggested: \(shouldReconnect)")
            
        case .cancelled:
            print("Connection cancelled")
            isConnected = false
            
        case .error(let error):
            print("Error: \(String(describing: error))")
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
//                    messageViewModel?.fetchMessanges(chatId: chatId)
//                    messageViewModel?.fetchChats()
                    
                    receivedMessage = chatId
                    receivedMessage = nil
                case "message_edited":
                    print("message_edited")
                case "message_deleted":
//                    messageViewModel?.fetchMessanges(chatId: chatId)
//                    messageViewModel?.fetchChats()
                    receivedMessage = chatId
                    receivedMessage = nil
                case "all_messages_read":
//                    messageViewModel?.readAllMessages(chatId: chatId)
//                    messageViewModel?.fetchChats()
                    receivedMessage = chatId
                    receivedMessage = nil
                default:
                    print("SOCKET ERROR")
                }
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
}

enum WebSocketLink {
    
    case localhost
    case remoteServer
    
    func createURL(urlComp:String) -> String {
        switch self {
        case .localhost:
            return "ws://localhost:4000?token=" + urlComp
        case .remoteServer:
            return "ws://duty-timer.sunfesty.ru:4000?token=" + urlComp
        }
    }
    
}
