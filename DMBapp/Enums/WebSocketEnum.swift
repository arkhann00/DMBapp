//
//  WebSocketEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.09.2024.
//

import Foundation

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
