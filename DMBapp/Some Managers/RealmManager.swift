//
//  RealmManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.06.2024.
//

import Foundation
import Combine
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private (set) var realm:Realm?
    
    private init() {
        configureRealm()
    }
    
    private func configureRealm() {
        do {
            let configuration = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = configuration
            realm = try Realm()
        } catch {
            print("ERROR CONFIGURE")
        }
    }
    
    
}
