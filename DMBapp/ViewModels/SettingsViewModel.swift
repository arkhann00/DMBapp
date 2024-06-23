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
    
    
    
}

extension SettingsViewModel:RefreshSettingsViewModelProtocol {
    func reloadView() {
        objectWillChange.send()
    }
}
