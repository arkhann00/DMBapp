//
//  ApplicationDelegateAdaptor.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 14.02.2025.
//

import UserNotifications
import UIKit

class ApplicationDelegateAdaptor: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка запроса разрешения: \(error)")
            } else {
                print("Разрешение на уведомления: \(granted ? "получено" : "не получено")")
            }
        }
    }
}
