//
//  DMBappApp.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.05.2024.
//

import SwiftUI

@main
struct YourApp: App {

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
