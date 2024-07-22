//
//  HomeViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    
    
    private let user = User.shared
    private let userDefaults = UserDefaultsManager.shared
    private let coreData = CoreDataManager.shared
    
    @Published var isBackgroundDim = false
    var settings = SettingsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init(source: SettingsViewModel = SettingsViewModel()) {
        user.status = userDefaults.string(forKey: .status)
        user.startDate = userDefaults.date(forKey: .startDate) ?? Date.now
        user.endDate = userDefaults.date(forKey: .endDate) ?? Date.now
        isBackgroundDim = userDefaults.bool(forKey: .isBackgroundDim) ?? false
        
        source.$bakcgroundState
            .map { state in
                return state
            }
            .sink {[weak self] state in
                
                self?.isBackgroundDim = state
                
            }
            .store(in: &cancellables)
    }
    
    func getIsDimBackground() -> Bool {
        return userDefaults.bool(forKey: .isBackgroundDim) ?? false
    }
    
    func isUserOnline() -> Bool {
        return user.isOnline
    }
    
    func getProgress() -> (Double, Double) {
        
        let fullProgress = Double(user.endDate.timeIntervalSince(user.startDate))
        let currentProgress = Double(Date.now.timeIntervalSince(user.startDate))
                        
        return (currentProgress, fullProgress)
        
    }
    
    func getPassedTime() -> (Int,Int,Int,Int) {
        return Int(Date.now.timeIntervalSince(user.startDate)).formatDateInTuple()
    }
    
    func getLeftTime() -> (Int,Int,Int,Int) {
        return Int(user.endDate.timeIntervalSince(Date.now)).formatDateInTuple()
    }
    
    func deleteStorageData() {
        userDefaults.remove(forKey: .status)
        userDefaults.remove(forKey: .isSavedData)
        userDefaults.remove(forKey: .startDate)
        userDefaults.remove(forKey: .endDate)
        userDefaults.remove(forKey: .backgroundImage)
        userDefaults.remove(forKey: .isBackgroundDim)
        userDefaults.remove(forKey: .language)
        let events = coreData.fetchAllEvents()
        
        for event in events ?? [] {
            coreData.deleteEvent(event: event)
            coreData.saveContext()
        }
        
    }
    
    func getDemobilizationDate(language:String) -> String {
        let endDate = user.endDate
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if language == "english" {
            formatter.locale = Locale(identifier: "en")
        }
        else {
            formatter.locale = Locale(identifier: "ru")
        }
        return formatter.string(from: endDate)
    }
    
    func getRemainingDays() -> Int {
        let sec = Int(user.endDate.timeIntervalSince(user.startDate))
        return sec/60/60/24
    }
    
    func getBackgroundImage() -> Image {
        
        guard let defaultData = UIImage(named: "MainBackground")?.pngData() else { return Image("MainBackground") }
        
        let backgroundUIImaage = UIImage(data: userDefaults.data(forKey: .backgroundImage) ?? defaultData)
        
        return Image(uiImage: backgroundUIImaage!)
        
    }
    
    func saveBackground(imageData data: Data?) {
        
        guard let imageData = data else { return }
        
        userDefaults.set(imageData, forKey: .backgroundImage)
        
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
}
