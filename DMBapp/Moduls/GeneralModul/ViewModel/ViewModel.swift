//
//  ViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 07.12.2024.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    
    let userDefaults = UserDefaultsManager.shared
    let networkManager = NetworkManager()
    let keychain = KeychainManager.shared
    let coreDataManager = CoreDataManager.shared
    
    func isAuthorizedUser() -> Bool {
        if let _ = keychain.load(key: .refreshToken) {
            return true
        }
        
        return false
    }
    
    func getUser() -> LocalUser {
        let nickname = userDefaults.string(forKey: .userNickname) ?? "None"
        let mail = userDefaults.string(forKey: .userLogin) ?? "None"
        var image:UIImage?
        let isAdmin = userDefaults.bool(forKey: .isAdminUser) ?? false
        if let imageData = userDefaults.data(forKey: .userAvatarImage), let uiImage = UIImage(data: imageData) {
            image = uiImage
        }
        let user = LocalUser(nickname: nickname, mail: mail, avatarImage: image, isAdmin: isAdmin)
        
        return user
        
    }
    
    func setPresentEvents() {
        if let startDate = userDefaults.date(forKey: .startDate), let endDate = userDefaults.date(forKey: .endDate) {
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            var date = Date()
            
            
            dateComponents.year = Date.now.getOnlyYear() + 1
            dateComponents.month = 12
            dateComponents.day = 1
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "Начало Зимы", date: date, id: "1")
            
            
            dateComponents.year = Date.now.monthNumber > 6 || (Date.now.monthNumber == 6 && Date.now.dayNumber > 1) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 6
            dateComponents.day = 1
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "Начало Лета", date: date, id: "2")
            
            
            dateComponents.year = Date.now.monthNumber > 9 || (Date.now.monthNumber == 9 && Date.now.dayNumber > 1) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 9
            dateComponents.day = 1
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "Начало Осени", date: date, id: "3")
            
            
            dateComponents.year = Date.now.monthNumber > 3 || (Date.now.monthNumber == 3 && Date.now.dayNumber > 1) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 3
            dateComponents.day = 1
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "Начало Весны", date: date, id: "4")
            
            
            let timeInterval = endDate.timeIntervalSince(startDate)
            date = Date(timeInterval: timeInterval, since: startDate)
            coreDataManager.addEvent(text: "Экватор", date: date, id: "5")
            
            
            date = endDate.minusDays(100) ?? Date.now
            coreDataManager.addEvent(text: "100 дней до дембеля", date: date, id: "6")
            
            
            
            date = endDate.minusDays(3) ?? Date.now
            coreDataManager.addEvent(text: "3 дня до дембеля", date: date, id: "7")
            
            
            dateComponents.year = Date.now.monthNumber > 2 || (Date.now.monthNumber == 2 && Date.now.dayNumber > 23) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 2
            dateComponents.day = 23
            date = calendar.date(from: dateComponents) ?? Date.now
            coreDataManager.addEvent(text: "День защитника Отечества", date: date, id: "8")
            
            
            dateComponents.year = Date.now.monthNumber > 5 || (Date.now.monthNumber == 5 && Date.now.dayNumber > 9) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 5
            dateComponents.day = 9
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "День Победы", date: date, id: "9")
            
            
            dateComponents.year = Date.now.monthNumber > 12 || (Date.now.monthNumber == 12 && Date.now.dayNumber > 31) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 12
            dateComponents.day = 31
            date = calendar.date(from: dateComponents) ?? Date.now
            coreDataManager.addEvent(text: "Новый Год", date: date, id: "10")
            
            
            dateComponents.year = Date.now.monthNumber > 1 || (Date.now.monthNumber == 1 && Date.now.dayNumber > 7) ? Date.now.getOnlyYear() + 1 : Date.now.getOnlyYear()
            dateComponents.month = 1
            dateComponents.day = 7
            
            date = calendar.date(from: dateComponents) ?? Date.now
            
            coreDataManager.addEvent(text: "Рождество Христово", date: date, id: "11")
            
            
            
            date = endDate.plusDays(1) ?? Date.now
            coreDataManager.addEvent(text: "Дембель", date: date, id: "12")
            
            
        }
    }
}
