//
//  SettingsViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.06.2024.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

class SettingsViewModel: ObservableObject {
    
    private let userDefaults = UserDefaultsManager.shared
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainManager.shared
    @Published var isSettingsEditing:Bool = false
    @Published var viewState:SettingsViewEnum = .none
    @Published var isBackgroundDim:Bool
    
    init() {
        isBackgroundDim = userDefaults.bool(forKey: .isBackgroundDim) ?? false
    }
    
    func updateSettings() {
        let parameters:Parameters = [
            "language" : "russian",
            "theme" : "light",
            "backgroundTint" : isBackgroundDim
        ]
        
        viewState = .loading
        networkManager.updateSettings(parameters: parameters) {[weak self] response in
            switch response.result {
            case .success(_):
                self?.userDefaults.set(self?.isBackgroundDim, forKey: .isBackgroundDim)
                self?.viewState = .successSavingSettings
                self?.isSettingsEditing = false
                print("SUCCESS SAVE SETTINGS")
            case .failure(_):
                self?.viewState = .failureSavingSettings
                self?.isSettingsEditing = true
                print("ERROR SAVE SETTINGS: \(response.printJsonError())")
            }
        }
    }
    
    func changeDates(startDate:Date, endDate:Date) {
        
        if startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
        
            if keychain.load(key: .accessToken) != nil {
                let timerParametrs = ["startTimeMillis" : Int64(((startDate.timeIntervalSince1970) * 1000)) , "endTimeMillis" : Int64(((endDate.timeIntervalSince1970) * 1000)) ]
                viewState = .loading
                networkManager.updateTimer(parametrs: timerParametrs) { [weak self] response in
                    
                    switch response.result {
                    case .success(_):
                        self?.viewState = .successSavingTimer
                        self?.isSettingsEditing = false
                        self?.userDefaults.set(startDate, forKey: .startDate)
                        self?.userDefaults.set(endDate, forKey: .endDate)
                        print("success timer update")
                    case .failure(_):
                        self?.viewState = .failureSavingTimer
                        if let data = response.data {
                            do {
                                let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                                print(networkError.message)
                            } catch {
                                print(response)
                            }
                        }
                        
                    }
                }
            } else {
                viewState = .successSavingTimer
                userDefaults.set(startDate, forKey: .startDate)
                userDefaults.set(endDate, forKey: .endDate)
            }
        }
    }
    
    func setBackgroundState(state: Bool) {
        userDefaults.set(state, forKey: .isBackgroundDim)
        
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
    
    func removeBackground() {
        let image = UIImage(named: "MainBackground")
        viewState = .loading
        guard let data = image!.pngData() else { return }
        networkManager.updateBackgroundImage(imageData: data) {[weak self] response in
            switch response.result {
            case .success(_):
                self?.viewState = .successRemoveBackgroundImage
                self?.userDefaults.set(data, forKey: .backgroundImage)
                print("SUCCESS REMOVE BACKGROUND IMAGE")
            case .failure(_):
                self?.viewState = .failureRemoveBackgroundImage
                print("FAILURE REMOVE BACKGROUND IMAGE: \(response.printJsonError())")
            }
        }
        
    }
    
}
