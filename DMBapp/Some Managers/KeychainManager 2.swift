//
//  KeychainManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.07.2024.
//

import Foundation
import Security

class KeychainManager {
    
    enum KeychainKeys: String {
        case refreshToken
        case accessToken
    }

    static let shared = KeychainManager()
    
    private init() {}
    
    func save(key: KeychainKeys, data: Data) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing items
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func loadData(key: KeychainKeys) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    func delete(key: KeychainKeys) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}

extension KeychainManager {
    
    func save(key: KeychainKeys, value: String) -> OSStatus {
        if let data = value.data(using: .utf8) {
            return save(key: key, data: data)
        }
        return errSecParam
    }
    
    func load(key: KeychainKeys) -> String? {
        guard let data = loadData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
