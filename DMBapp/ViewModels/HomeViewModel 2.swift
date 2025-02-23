//
//  HomeViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI
import Foundation
import Combine

class HomeViewModel: ViewModel {

    private var startDate = Date.now
    private var endDate = Date.now
    @Published var user:User?
    @Published var viewState:HomeViewState = .none
    @Published var isBackgroundDim = false
    @Published var friends:[UserData] = []
    @Published var friendshipInvites:[SenderUser] = []
    @Published var users:[UserData] = []
    @Published var sentFriendshipInvites:[RecieverUser] = []
    
    override init() {
        super.init()
        isBackgroundDim = self.userDefaults.bool(forKey: .isBackgroundDim) ?? false
        Task {
            await fetchSentFriendshipInvites()
            await fetchTimer()
        }
        
    }
    
    func getUserName() -> String {
        return userDefaults.string(forKey: .userName) ?? "None"
    }
    
    func isRegisteredUser() -> Bool {
        if userDefaults.int64(forKey: .accessTime) == nil || Int64(Date.now.timeIntervalSince1970) - (userDefaults.int64(forKey: .refreshTime) ?? 0) >= 2592000 {
            return false
        }
        return true
    }
    
    func fetchTimer() {
        
        networkManager.getTimer {[weak self] result in
            switch result {
            case .success(let timer):
                self?.userDefaults.set(timer.startTimeMillis.convertFromInt64ToDate(), forKey: .startDate)
                self?.userDefaults.set(timer.endTimeMillis.convertFromInt64ToDate(), forKey: .endDate)
                self?.startDate = timer.startTimeMillis.convertFromInt64ToDate()
                self?.endDate = timer.endTimeMillis.convertFromInt64ToDate()
            case .failure(let error):
                if let startDate = self?.userDefaults.date(forKey: .startDate), let endDate = self?.userDefaults.date(forKey: .endDate) {
                    self?.startDate = startDate
                    self?.endDate = endDate
                } else {}
                print("ERROR GET TIMER: \(error.localizedDescription)")
            }
        }
        
    }
    
    @MainActor
    func updateToken() async {
        if self.isAuthorizedUser() {
            if Int64(Date.now.timeIntervalSince1970) - (userDefaults.int64(forKey: .refreshTime) ?? 0) < 2592000 {
                await networkManager.updateTokens {[self] response in
                    let result = response.result
                    switch result {
                    case .success(let auth):
                        print(auth.accessToken)
                        let _ = keychain.save(key: .accessToken, value: auth.accessToken)
                        let _ = keychain.save(key: .refreshToken, value: auth.refreshToken)
                        userDefaults.set(auth.accessTokenExpiresAt, forKey: .accessTime)
                        userDefaults.set(auth.refreshTokenExpiresAt, forKey: .refreshTime)
                        viewState = .successUpdateToken
                    case .failure(let error):
                        print("ERROR UPDATE TOKENS: \(error.localizedDescription)")
                        viewState = .failureUpdateToken
                    }
                }
            }
        }
    }

    @MainActor
    func fetchSentFriendshipInvites() async {
        await networkManager.fetchSentFriendshipInvitesList {[weak self] result in
            switch result {
            case .success(let sentFriendshipInvites):
                self?.sentFriendshipInvites = sentFriendshipInvites
            case .failure(let error):
                print("FAILURE fetchSentFriendshipInvites: \(error.localizedDescription)")
            }
        }
    }
    
    func getIsDimBackground() -> Bool {
        return userDefaults.bool(forKey: .isBackgroundDim) ?? false
    }
    
    func isUserOnline() -> Bool {
        return Int64(Date.now.timeIntervalSince1970) - (userDefaults.int64(forKey: .refreshTime) ?? 0) < 2592000 ? true : false
    }
    
    func getProgress() -> (Double, Double) {
        
        let fullProgress = Double((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince((userDefaults.date(forKey: .startDate) ?? Date.now)))
        let currentProgress = Double(Date.now.timeIntervalSince((userDefaults.date(forKey: .startDate) ?? Date.now)))
                        
        return (currentProgress, fullProgress)
        
    }
    
    func getPassedTime() -> (Int,Int,Int,Int) {
        return Int(Date.now.timeIntervalSince((userDefaults.date(forKey: .startDate) ?? Date.now))).formatDateInTuple()
    }
    
    func getLeftTime() -> (Int,Int,Int,Int) {
        return Int((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince(Date.now)).formatDateInTuple()
    }
    
    func getDemobilizationDate(language:String) -> String {
        let endDate = (userDefaults.date(forKey: .endDate) ?? Date.now)
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
        let sec = Int((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince(Date.now))
        return sec/60/60/24
    }
    
    func getBackgroundImage() -> Image {
        
        guard let defaultData = UIImage(named: "DefaultBackground")?.pngData() else { return Image("DefaultBackground") }
        
        let backgroundUIImaage = UIImage(data: userDefaults.data(forKey: .backgroundImage) ?? defaultData)
        
        return Image(uiImage: backgroundUIImaage!)
        
        
        
    }
    
    func saveBackground(imageData data: Data?) {
        
        guard let imageData = data else { return }
        
        userDefaults.set(imageData, forKey: .backgroundImage)
        
    }
    
}
