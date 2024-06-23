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
}

final class UserDefaultsManager{
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    public enum Keys: String {
        
        case status
        case startDate
        case endDate
        case isSavedData
        case isBackgroundDim
        
    }
    
    private let userDefaults = UserDefaults.standard
    
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
    
    func remove(forKey key: Keys){
        
        userDefaults.removeObject(forKey: key.rawValue)
        
    }
    
}
