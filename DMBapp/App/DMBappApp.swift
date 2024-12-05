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
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .onAppear(perform: {
                    Task {
                        await networkManager.setStatusOnline { result in
                            switch result {
                            case .success(_):
                                print("SUCCESS SET STATUS ONLINE")
                            case .failure(let error):
                                print("FAILURE SET STATUS ONLINE: \(error.localizedDescription)")
                            }
                        }
                    }
                })
                .onDisappear(perform: {
                    Task {
                        await networkManager.setStatusOffline { result in
                            switch result {
                            case .success(_):
                                print("SUCCESS SET STATUS OFFLINE")
                            case .failure(let error):
                                print("FAILURE SET STATUS OFFLINE: \(error.localizedDescription)")
                            }
                        }
                    }
                })

          
        }
    }
}

