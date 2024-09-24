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
    
    private let userDefaults = UserDefaultsManager.shared
    private let coreData = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainManager.shared
    private var startDate = Date.now
    private var endDate = Date.now
    @Published var user:User?
    @Published var viewState:HomeViewState = .none
    @Published var isBackgroundDim = false
    @Published var friends:[UserData] = []
    @Published var friendshipInvites:[SenderUser] = []
    @Published var users:[UserData] = []
    @Published var sentFriendshipInvites:[RecieverUser] = []
    @Published var fiendsRequestState:RequestResult = .none
    
    init(viewState:HomeViewState = .none) {
        self.viewState = viewState
        isBackgroundDim = userDefaults.bool(forKey: .isBackgroundDim) ?? false
        fetchUser()
        fetchFriends()
        fetchFriendshipInvites()
        fetchSentFriendshipInvites()
        fetchTimer()
    }
    
    func isRegisteredUser() -> Bool {
        if userDefaults.int64(forKey: .accessTime) == nil || Int64(Date.now.timeIntervalSince1970) - (userDefaults.int64(forKey: .refreshTime) ?? 0) >= 2592000 {
            return false
        }
        return true
    }
    
    func isAuthorizedUser() -> Bool {
        if let _ = keychain.load(key: .refreshToken) {
            return true
        }
        
        return false
    }
    
    func fetchTimer() {
        viewState = .loading
        networkManager.getTimer {[weak self] result in
            switch result {
            case .success(let timer):
                self?.viewState = .successFetchTimer
                self?.userDefaults.set(timer.startTimeMillis.convertFromInt64ToDate(), forKey: .startDate)
                self?.userDefaults.set(timer.endTimeMillis.convertFromInt64ToDate(), forKey: .endDate)
                self?.startDate = timer.startTimeMillis.convertFromInt64ToDate()
                self?.endDate = timer.endTimeMillis.convertFromInt64ToDate()
            case .failure(let error):
                self?.viewState = .failureFetchTimer
                if let startDate = self?.userDefaults.date(forKey: .startDate), let endDate = self?.userDefaults.date(forKey: .endDate) {
                    self?.startDate = startDate
                    self?.endDate = endDate
                } else {}
                print("ERROR GET TIMER: \(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchUser() {
        networkManager.getUserData { [weak self] response in
            let result = response.result
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(_):
                
                if let id = self?.userDefaults.integer(forKey: .userId), let login = self?.userDefaults.string(forKey: .userLogin), let name = self?.userDefaults.string(forKey: .userName), let nickname = self?.userDefaults.string(forKey: .userNickname), let userType = self?.userDefaults.string(forKey: .userType) {
                    
                    self?.user = User(id: id, login: login, name: name, nickname: nickname, avatarLink: self?.userDefaults.string(forKey: .userAvatarImage), userType: userType)
                }
                
                print("FAILURE FETCH USER:\(response)")
                if let data = response.data {
                    do {
                        let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                        print("USER ERROR: \(networkError.message)")
                    } catch {
                        print("")
                    }
                }
            }
        }
        
    }
    
    func updateAvatarImage(image:UIImage) {
        viewState = .loading
        networkManager.updateImage(image: image) { [weak self] result in
            switch result {
            case .success(_):
                self?.userDefaults.set((image.pngData())!, forKey: .userAvatarImage)
                self?.viewState = .successUpdateAvatarImage
                print("SUCCESS UPLOAD IMAGE")
            case .failure(let error):
                self?.viewState = .failureUpdateAvatarImage
                print("FAILURE UPLOAD IMAGE: \(error.localizedDescription)")
            }
        }
    }
    
    func getUser() -> User? {
        
        guard let id = userDefaults.integer(forKey: .userId), let login = userDefaults.string(forKey: .userLogin), let name = userDefaults.string(forKey: .userName), let nickname = userDefaults.string(forKey: .userNickname), let userType = userDefaults.string(forKey: .userType)
        else { return nil }
        
        return User(id: id, login: login, name: name, nickname: nickname, avatarLink: userDefaults.string(forKey: .userAvatarImage), userType: userType)
        
    }
    
    
    
    func fetchSentFriendshipInvites() {
        networkManager.fetchSentFriendshipInvitesList {[weak self] result in
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
    
    func deleteStorageData() {
        userDefaults.remove(forKey: .status)
        userDefaults.remove(forKey: .isSavedData)
        userDefaults.remove(forKey: .startDate)
        userDefaults.remove(forKey: .endDate)
        userDefaults.remove(forKey: .backgroundImage)
        userDefaults.remove(forKey: .isBackgroundDim)
        userDefaults.remove(forKey: .language)
        userDefaults.remove(forKey: .accessTime)
        userDefaults.remove(forKey: .refreshTime)
        userDefaults.remove(forKey: .userId)
        userDefaults.remove(forKey: .userName)
        userDefaults.remove(forKey: .userType)
        userDefaults.remove(forKey: .userLogin)
        userDefaults.remove(forKey: .userNickname)
        userDefaults.remove(forKey: .userAvatarImage)
        
        let _ = keychain.delete(key: .accessToken)
        let _ = keychain.delete(key: .refreshToken)
        
        let events = coreData.fetchAllEvents()
        
        for event in events ?? [] {
            coreData.deleteEvent(event: event)
            coreData.saveContext()
        }
        
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
        
        guard let defaultData = UIImage(named: "MainBackground")?.pngData() else { return Image("MainBackground") }
        
        let backgroundUIImaage = UIImage(data: userDefaults.data(forKey: .backgroundImage) ?? defaultData)
        
        return Image(uiImage: backgroundUIImaage!)
        
        
        
    }
    
    func fetchSettings() {
        networkManager.fetchSettings { response in
            switch response.result {
            case .success(let settings):
                print(settings)
            case .failure(_):
                print(response.printJsonError())
            }
        }
    }
    
    func saveBackground(imageData data: Data?) {
        
        guard let imageData = data else { return }
        
        networkManager.updateBackgroundImage(imageData: imageData) { response in
            switch response.result {
                case .success(_):
                print("SUCCESS SAVE BACKGROUND")
            case .failure(_):
                print("FAILURE SAVE BACKGROUND: \(response.printJsonError())")
            }
        }
        
        userDefaults.set(imageData, forKey: .backgroundImage)
        
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    func deleteAccount() {
        
        networkManager.deleteAccount {[weak self] result in
            switch result {
            case .success(_):
                self?.deleteStorageData()
                print("SUCCESS DELETE ACCOUNT")
            case .failure(let error):
                print("FAILURE DELETE ACCOUNT: \(error.localizedDescription)")
            }
        }
    }
    
    func logOut() {
        deleteStorageData()
        networkManager.logOut { result in
            switch result {
            case .success(_):
                print("SUCCESS LOGOUT")
            case .failure(let error):
                print("ERROR LOGOUT: \(error.localizedDescription)")
            }
        }
    }
    
   
    
    
    private func deleteCurrentUser() {
        if !users.isEmpty {
            for i in 0 ..< users.count {
                if users[i].id == self.user?.id {
                    users.remove(at: i)
                }
            }
        }
    }
    
    func isMyFriend(with id:Int) -> Bool {
        for person in friends {
            if person.id == id {
                return true
            }
        }
        return false
    }
    
    func isInviteSended(with id:Int) -> Bool {
        for person in sentFriendshipInvites {
            if person.id == id {
                return true
            }
        }
        return false
    }
    
    func sendFriendshipInvite(id: Int) {
        networkManager.sendFriendshipInvite(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                self?.sentFriendshipInvites.removeAll()
                self?.fetchSentFriendshipInvites()
                print("SUCCESS SEND  FRIENDSHIP INVITE")
            case .failure(let error):
                print("FAILURE SEND  FRIENDSHIP INVITE:\(error.localizedDescription)")
            }
        }
    }
    
    func isAlreadySentFriendshipInvite(with id: Int) -> Bool {
        for person in sentFriendshipInvites {
            if person.recieverId == id {
                return true
            }
        }
        return false
    }
    
    
    
    // MARK: - Network Requests
    
    func acceptFriendshipInvite(id:Int) {
        
        viewState = .loading
        
        networkManager.acceptFriendshipInvite(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                print("SUCCESS ACCEPT FRIENDSHIP INVITE")
                self?.friendshipInvites.removeAll()
                self?.fetchFriendshipInvites()
                self?.fetchFriends()
                self?.viewState = .successAcceptFriendshipInvite
            case .failure(let error):
                print("FAILURE ACCEPT FRIENDSHIP INVITE: \(error.localizedDescription)")
                self?.viewState = .failureAcceptFriendshipInvite
            }
        }
    }
    
    func deleteFromFriends(id:Int) {
        
        viewState = .loading
        
        networkManager.deleteFriend(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                print("SUCCESS DELETE FRIEND")
                self?.friends.removeAll()
                self?.fetchFriends()
                self?.viewState = .successDeleteFromFriends
            case .failure(let error):
                print("FAILURE DELETE FRIEND: \(error.localizedDescription)")
                self?.viewState = .failureDeleteFromFriends
            }
        }
    }
    
    func fetchFriends() {
        
        viewState = .loading
        
        networkManager.fetchFriendsList {[weak self] result in
            switch result {
            case .success(let friends):
                self?.friends.removeAll()
                self?.friends = friends
                self?.viewState = .successFetchFriends
            case .failure(let error):
                print("ERROR FETCH FRIENDS:\(error.localizedDescription)")
                self?.viewState = .failureFetchFriends
            }
        }
    }
    
    func fetchFriendshipInvites() {
        
        viewState = .loading
        
        networkManager.fetchFriendshipInvitesList { [weak self] result in
            switch result {
            case .success(let invites):
                self?.friendshipInvites.removeAll()
                self?.friendshipInvites = invites
                self?.viewState = .successFetchFriendshipInvites
            case .failure(let error):
                print("ERROR FETCH FRIENDSHIP INVITES:\(error.localizedDescription)")
                self?.viewState = .failureFetchFriendshipInvites
            }
        }
    }
    
    func searchUserWithName(name:String) {
        
        viewState = .loading
        
        networkManager.searchUsersWithName(name: name) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.deleteCurrentUser()
                self?.viewState = .successSearchUserWithName
            case .failure(let error):
                print("ERROR SEARCHUSERS:\(error.localizedDescription)")
                self?.viewState = .failureSearchUserWithName
            }
        }
        
    }
    

    
    
    
}
