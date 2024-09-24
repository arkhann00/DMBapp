//
//  DMBappApp.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.05.2024.
//

import SwiftUI

@main
struct YourApp: App {
    
    let networkManager = NetworkManager.shared
    @State var isPresent = true
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .onAppear(perform: {
                    networkManager.setStatusOnline { result in
                        switch result {
                        case .success(_):
                            print("SUCCESS SET STATUS ONLINE")
                        case .failure(let error):
                            print("FAILURE SET STATUS ONLINE: \(error.localizedDescription)")
                        }
                    }
                })
                .onDisappear(perform: {
                    networkManager.setStatusOffline { result in
                        switch result {
                        case .success(_):
                            print("SUCCESS SET STATUS OFFLINE")
                        case .failure(let error):
                            print("FAILURE SET STATUS OFFLINE: \(error.localizedDescription)")
                        }
                    }
                })

          
        }
    }
}

