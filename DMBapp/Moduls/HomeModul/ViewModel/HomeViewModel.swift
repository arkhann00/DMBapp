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
    @Published var backgroundImage:Image = Image("MainBackground")
    @Published var viewState:HomeViewState = .none
    @Published var isBackgroundDim = false
    @Published var friends:[UserData] = []
    @Published var friendshipInvites:[SenderUser] = []
    @Published var users:[UserData] = []
    @Published var sentFriendshipInvites:[RecieverUser] = []
    
    override init() {
        super.init()
        self.viewState = viewState
        isBackgroundDim = userDefaults.bool(forKey: .isBackgroundDim) ?? false
        if let data = userDefaults.data(forKey: .backgroundImage), let uiImage = UIImage(data: data) {
            self.backgroundImage = Image(uiImage: uiImage)
        }
    }
    
    func isRegisteredUser() -> Bool {
        if userDefaults.int64(forKey: .accessTime) == nil || Int64(Date.now.timeIntervalSince1970) - (userDefaults.int64(forKey: .refreshTime) ?? 0) >= 2592000 {
            return false
        }
        return true
    }
    
    func fetchTimer() {
        
        if let startDate = userDefaults.int64(forKey: .startDate)?.convertFromInt64ToDate(), let endDate = userDefaults.int64(forKey: .endDate)?.convertFromInt64ToDate(){
            self.startDate = startDate
            self.endDate = endDate
        } 

    }
    
    
    func getUserName() -> String {
        if let name = userDefaults.string(forKey: .userName) {
            return name
        } else {
            return "None"
        }
    }
    
    func getEndDate() -> Date? {
        return userDefaults.date(forKey: .endDate)
    }
    
    func getStartDate() -> Date? {
        return userDefaults.date(forKey: .startDate)
    }
    
    func isDMBEnd() -> Bool {
        
        guard let endDate = userDefaults.date(forKey: .endDate) else { return false }
        
        if endDate.timeIntervalSince1970 < Date.now.timeIntervalSince1970 {
            return true
        } else {
            return false
        }
    }
    
    func shareTimerImage() -> UIImage {
        
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let timerSheetView = TimerSheet(user: getUser(), remainDays: getRemainingDays(), totalDays: totalProgress().0, progress: getProgressRelation(), image: getBackgroundImage(), isDMBStart: isDMBStart(), isDMBEnd: isDMBEnd())
        let renderedImage = timerSheetView.asUIImage(size: targetSize)
        return renderedImage
        
        
    }
    
    func isDMBStart() -> Bool {
        
        guard let startDate = userDefaults.date(forKey: .startDate) else { return false }
        
        if startDate.timeIntervalSince1970 > Date.now.timeIntervalSince1970 {
            return false
        } else {
            return true
        }
    }
    
    func updateAvatarImage(image:UIImage) {
        viewState = .loading
        
        networkManager.updateAvatarImage(image: image) { [weak self] result in
            switch result {
            case .success(_):
                self?.userDefaults.set((image.pngData())!, forKey: .userAvatarImage)
                print(self?.userDefaults.data(forKey: .userAvatarImage))
                self?.viewState = .successUpdateAvatarImage
                print("SUCCESS UPLOAD IMAGE")
            case .failure(let error):
                self?.viewState = .failureUpdateAvatarImage
                print("FAILURE UPLOAD IMAGE: \(error.localizedDescription)")
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
    
    func getProgress() -> (Date, Date) {
        
        return (userDefaults.date(forKey: .startDate) ?? Date.now, userDefaults.date(forKey: .endDate) ?? Date.now.addingTimeInterval(3153600))
        
    }/*31 536 000*/
    
    func getProgressRelation() -> (Double, Double) {
        
        let fullProgress = Double((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince((userDefaults.date(forKey: .startDate) ?? Date.now)))
        let currentProgress = Double(Date.now.timeIntervalSince((userDefaults.date(forKey: .startDate) ?? Date.now)))
        
        return (currentProgress, fullProgress)
        
    }/*31 536 000*/
    
    func totalProgress() -> (Int, Int, Int, Int) {
        guard let startDate = userDefaults.date(forKey: .startDate), let endDate = userDefaults.date(forKey: .endDate) else { return (365, 0, 0, 0)}
        
        return Int(endDate.timeIntervalSince(startDate)).formatDateInTuple()
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
        userDefaults.remove(forKey: .userType)
        userDefaults.remove(forKey: .userLogin)
        userDefaults.remove(forKey: .userNickname)
        userDefaults.remove(forKey: .userAvatarImage)
        userDefaults.remove(forKey: .backgroundImage)
        
        let _ = keychain.delete(key: .accessToken)
        let _ = keychain.delete(key: .refreshToken)
        
        let events = coreDataManager.fetchAllEvents()
        
        for event in events ?? [] {
            coreDataManager.deleteEvent(event: event)
            coreDataManager.saveContext()
        }
        
    }
    
    func getDemobilizationDate() -> String {
        let endDate = (userDefaults.date(forKey: .endDate) ?? Date.now)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
    
    func findNearestEvent() -> Event? {
        guard !isDMBEnd() else { return nil }
        let events = coreDataManager.fetchAllEvents()
        
        let currentDate = Date.now
        
        var nearestEvent:Event? = nil
        
        for event in events ?? [] {
            if currentDate.timeIntervalSince1970 < event.date?.timeIntervalSince1970 ?? 0 {
                if nearestEvent == nil {
                    nearestEvent = event
                } else {
                    if nearestEvent?.date?.timeIntervalSince1970 ?? 1e9 > event.date?.timeIntervalSince1970 ?? 0 {
                        nearestEvent = event
                    }
                }
            }
        }
        
        return nearestEvent
    }
    
    func getAvatarImage() -> UIImage {
        if let data = userDefaults.data(forKey: .userAvatarImage), let avatarUIImaage = UIImage(data: data) {
            return avatarUIImaage
        }
        else {
            return UIImage(systemName: "person.fill")!
        }
    }
    @MainActor
    func removeAvatarImage() async {
        
        await networkManager.deleteAvatarImage {[weak self] response in
            switch response.result {
            case .success(_):
                self?.userDefaults.set(nil, forKey: .userAvatarImage)
                print(self?.userDefaults.data(forKey: .userAvatarImage))
                print("success removed avatar image")
            case .failure(_):
                print("failure removed avatar image")
            }
        }
        
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
    
    @MainActor
    func saveBackground(imageData data: Data?) async {
        
        viewState = .loading
        if let imageData = data {
            await networkManager.updateBackgroundImage(imageData: imageData) {[weak self] response in
                switch response.result {
                case .success(_):
                    self?.userDefaults.set(imageData, forKey: .backgroundImage)
                    self?.backgroundImage = Image(uiImage: UIImage(data: imageData)!)
                    self?.viewState = .successUpdateAvatarImage
                    print("SUCCESS SAVE BACKGROUND")
                case .failure(_):
                    self?.viewState = .failureUpdateAvatarImage
                    print("FAILURE SAVE BACKGROUND: \(response.printJsonError())")
                }
            }
        } else {
            await networkManager.deleteBackgroundImage {[weak self] response in
                switch response.result {
                case .success(_):
                    self?.userDefaults.set(nil, forKey: .backgroundImage)
                    print("SUCCESS DELETE BACKGROUND IMAGE")
                case .failure(_):
                    response.printJsonError()
                }
            }
        }
        
        
        
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    @MainActor
    func deleteAccount() async {
        
        await networkManager.deleteAccount {[weak self] result in
            switch result {
            case .success(_):
                self?.deleteStorageData()
                print("SUCCESS DELETE ACCOUNT")
            case .failure(let error):
                print("FAILURE DELETE ACCOUNT: \(error.localizedDescription)")
            }
        }
    }
    @MainActor
    func logOut() async {
        deleteStorageData()
        
        await networkManager.logOut { result in
            switch result {
            case .success(_):
                print("SUCCESS LOGOUT")
            case .failure(let error):
                print("ERROR LOGOUT: \(error.localizedDescription)")
            }
        }
    }
    
    
    @MainActor
    func sendFriendshipInvite(id: String) async {
        await networkManager.sendFriendshipInvite(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                Task {
                    await self?.sentFriendshipInvites.removeAll()
                    
                    await self?.fetchSentFriendshipInvites()
                }
                self?.viewState = .successSendFriendshipInvite
                print("SUCCESS SEND  FRIENDSHIP INVITE")
            case .failure(let error):
                self?.viewState = .failureSendFriendshipInvite
                print("FAILURE SEND  FRIENDSHIP INVITE:\(error.localizedDescription)")
            }
        }
    }
    // MARK: - Network Requests
    @MainActor
    func acceptFriendshipInvite(id:String) async {
        
        viewState = .loading
        
        await networkManager.acceptFriendshipInvite(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                print("SUCCESS ACCEPT FRIENDSHIP INVITE")
                self?.friendshipInvites.removeAll()
                Task {
                    await self?.fetchFriendshipInvites()
                }
                Task {
                    await self?.fetchFriends()
                }
                self?.viewState = .successAcceptFriendshipInvite
            case .failure(let error):
                print("FAILURE ACCEPT FRIENDSHIP INVITE: \(error.localizedDescription)")
                self?.viewState = .failureAcceptFriendshipInvite
            }
        }
    }
    @MainActor
    func deleteFromFriends(id:String) async {
        
        viewState = .loading
        
        await networkManager.deleteFriend(personId: id) {[weak self] result in
            switch result {
            case .success(_):
                print("SUCCESS DELETE FRIEND")
                self?.friends.removeAll()
                Task {
                    await self?.fetchFriends()
                }
                self?.viewState = .successDeleteFromFriends
            case .failure(let error):
                print("FAILURE DELETE FRIEND: \(error.localizedDescription)")
                self?.viewState = .failureDeleteFromFriends
            }
        }
    }
    @MainActor
    func fetchFriends() async {
        
        viewState = .loading
        await networkManager.fetchFriendsList {[weak self] result in
            switch result {
            case .success(let friends):
                self?.friends.removeAll()
                self?.friends = friends
                self?.viewState = .successFetchFriends
                print(self?.friends.count)
            case .failure(let error):
                print("ERROR FETCH FRIENDS:\(error.localizedDescription)")
                self?.viewState = .failureFetchFriends
            }
        }
    }
    
    @MainActor
    func fetchFriendshipInvites() async {
        
        viewState = .loading
        
        await networkManager.fetchFriendshipInvitesList { [weak self] result in
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
    
    
    
    

    
    
    
}
