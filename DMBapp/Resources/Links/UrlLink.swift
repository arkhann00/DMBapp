//
//  UrlLink.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation

enum UrlLink {
    
    case localhost
    case prodServer
    case testServer
    
    func createURL(urlComp:String) -> String {
        switch self {
        case .localhost:
            return "http://127.0.0.1:3000" + urlComp
        case .prodServer:
            return "https://duty-timer.sunfesty.ru" + urlComp
        case .testServer:
            return "http://93.183.82.224:3000" + urlComp
            
        }
    }
    
}
