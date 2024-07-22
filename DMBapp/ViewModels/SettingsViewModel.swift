//
//  SettingsViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.06.2024.
//

import Foundation
import Combine

protocol RefreshSettingsViewModelProtocol {
    func reloadView()
}

class SettingsViewModel: ObservableObject {
    
    private let userDefaults = UserDefaultsManager.shared
    @Published var bakcgroundState:Bool
    
    init() {
        bakcgroundState = userDefaults.bool(forKey: .isBackgroundDim) ?? false
    }
    
    func changeLanguage() {
        
    }
    
    func setBackgroundState(state: Bool) {
        userDefaults.set(state, forKey: .isBackgroundDim)
        
    }
    
    func getBackgroundState() -> Bool {
        guard let state = userDefaults.bool(forKey: .isBackgroundDim) else { return false }
        return state
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    func changeLanguage(language:String) {
        if language == "russian" {
            userDefaults.set(language, forKey: .language)
            return
        }
        if language == "english" {
            userDefaults.set(language, forKey: .language)
            return
        }
        
    }
    
}

extension SettingsViewModel:RefreshSettingsViewModelProtocol {
    func reloadView() {
        objectWillChange.send()
    }
}
