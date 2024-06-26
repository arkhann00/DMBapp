//
//  DMBappApp.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.05.2024.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let userDefaults = UserDefaultsManager.shared
    var isSavesdData = false

    var body: some Scene {
        WindowGroup {
            if userDefaults.bool(forKey: .isSavedData) == nil || userDefaults.bool(forKey: .isSavedData) == false {
                StatusView()
                    .environmentObject(CalendarViewModel())
                    .ignoresSafeArea()
            }
            else {
                CustomTabBar()
                    .environmentObject(CalendarViewModel())
                    .navigationBarBackButtonHidden()
                
            }
        }
    }
}
