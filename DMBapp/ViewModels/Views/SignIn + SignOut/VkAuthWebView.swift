//
//  VkAuthWebView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.07.2024.
//

import Foundation
import SwiftUI
import WebKit

struct VkAuthWebView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: appID)
        ]
        
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
