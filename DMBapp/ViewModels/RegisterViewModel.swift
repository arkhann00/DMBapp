//
//  RegisterViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.05.2024.
//

import Foundation
import Combine
import RealmSwift

class RegisterViewModel: ObservableObject {
    
    private var user = User.shared
    private let userDefaults = UserDefaultsManager.shared
    private var realm:Realm?
    
    @Published var startDate = Date.now
    @Published var endDate = Date.now.addingTimeInterval(31536000)
    var cancellanle: AnyCancellable?
    
    init(){
        configureRealm()
    }
    
    func isDatesValid() -> Bool {
        
        return true
    }
    
    func startDateWasChanged() {
        endDate = startDate.addingTimeInterval(31536000)
    }
        
    func setSatus(status: String) {
        userDefaults.set(status, forKey: .status)
        user.status = status
    }
    
    func setStartDate() {
        userDefaults.set(startDate, forKey: .startDate)
        user.startDate = startDate
    }
    
    func setEndDate() {
        userDefaults.set(endDate, forKey: .endDate)
        user.endDate = endDate
    }
    
    
    func isDataSaved() {
        userDefaults.set(true, forKey: .isSavedData)
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
