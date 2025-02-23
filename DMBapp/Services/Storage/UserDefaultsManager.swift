//
//  UserDefaultsManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import Foundation

protocol UserDefaultsManagerProtocol{
    
    func set(_ object:Any?, forKey key: UserDefaultsManager.Keys)
    func string(forKey key:UserDefaultsManager.Keys) -> String?
    func double(forKey key: UserDefaultsManager.Keys) -> Double?
    func remove(forKey key: UserDefaultsManager.Keys)
    func bool(forKey key: UserDefaultsManager.Keys) -> Bool?
    func integer(forKey key: UserDefaultsManager.Keys) -> Int?
    func date(forKey key: UserDefaultsManager.Keys) -> Date?
    func int64(forKey key:UserDefaultsManager.Keys) -> Int64?
}

final class UserDefaultsManager{
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults:UserDefaults
    
    private init() {
        if let userDefaults = UserDefaults(suiteName: "group.ankh.DMBapp") {
            self.userDefaults = userDefaults
        } else {
            self.userDefaults = UserDefaults.standard
        }
    }
    
    enum Keys: String {
        
        case status
        case startDate
        case endDate
        case isSavedData
        case isBackgroundDim
        case backgroundImage
        case language
        // Таймеры токенов
        case accessTime
        case refreshTime
        // Данные пользователя
        case userId
        case userName
        case userNickname
        case userLogin
        case userAvatarImage
        case userType
        case isAdminUser
        case userStatus
    }
    
    private func store(_ object:Any?, key: String){
        userDefaults.set(object, forKey: key)
    }
    
    private func restore(forKey key:String) -> Any?{
        userDefaults.object(forKey: key)
    }
    
}

extension UserDefaultsManager: UserDefaultsManagerProtocol {
        
    func set(_ object: Any?, forKey key: Keys) {
        store(object, key: key.rawValue)
    }
    
    func string(forKey key: Keys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
    
    func bool(forKey key: Keys) -> Bool? {
        restore(forKey: key.rawValue) as? Bool
    }
    
    func double(forKey key: Keys) -> Double? {
        restore(forKey: key.rawValue) as? Double
    }
    
    func integer(forKey key: Keys) -> Int? {
        restore(forKey: key.rawValue) as? Int
    }
    
    func date(forKey key: Keys) -> Date? {
        restore(forKey: key.rawValue) as? Date
    }
    
    func data(forKey key: Keys) -> Data? {
        restore(forKey: key.rawValue) as? Data
    }
    
    func int64(forKey key: Keys) -> Int64? {
        restore(forKey: key.rawValue) as? Int64
    }
    
    func remove(forKey key: Keys){
        
        userDefaults.removeObject(forKey: key.rawValue)
        
    }
    
}
