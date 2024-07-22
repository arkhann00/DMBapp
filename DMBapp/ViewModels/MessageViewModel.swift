//
//  MessageViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.07.2024.
//

import Foundation
import Combine

class MessageViewModel:ObservableObject {
    
    let userDefaults = UserDefaultsManager.shared
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
}
