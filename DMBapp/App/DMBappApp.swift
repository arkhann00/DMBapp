//
//  DMBappApp.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.05.2024.
//

import SwiftUI

@main
struct YourApp: App {
    
    let networkManager = NetworkManager()
    @State var isPresent = true
    @UIApplicationDelegateAdaptor(ApplicationDelegateAdaptor.self) var appDelegateAdaptor
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .colorScheme(.dark)
        }
    }
} 
