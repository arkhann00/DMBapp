//
//  KeychainManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 30.10.2024.
//

import Foundation
import Security



class KeychainManager {
    static let shared = KeychainManager()

    private init() {}
    
    enum KeychainKey: String {
        case accessToken
        case refreshToken
    }

    // Функция для сохранения строки в Keychain
    func save(key: KeychainKey, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        // Удаляем существующий элемент, если он есть
        SecItemDelete(query as CFDictionary)
        
        // Добавляем новый элемент в Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // Функция для загрузки строки из Keychain
    func load(key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let value = String(data: data, encoding: .utf8) {
                return value
            }
        }
        return nil
    }

    // Функция для удаления строки из Keychain
    func delete(key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
