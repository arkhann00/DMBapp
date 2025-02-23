//
//  CalendarViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class MenuViewModel: ViewModel {
    
    @Published var days:[Day] = []
    @Published var events:[Event] = []
    @Published var viewState:MenuViewState = .none
  
    override init() {
        super.init()
    }
    
    @MainActor
    func saveBackground(imageData data: Data) async {
        
        if isAuthorizedUser() {
            viewState = .loadingUpdateBackgroundImage
            
            await networkManager.updateBackgroundImage(imageData: data) {[weak self] response in
                switch response.result {
                case .success(_):
                    self?.userDefaults.set(data, forKey: .backgroundImage)
                    self?.viewState = .successUpdateBackgroundImage
                    print("SUCCESS SAVE BACKGROUND")
                case .failure(_):
                    self?.viewState = .failureUpdateBackgroundImage
                    print("FAILURE SAVE BACKGROUND: \(response.printJsonError())")
                }
                
            }
        } else {
            self.userDefaults.set(data, forKey: .backgroundImage)
        }
        
        
        
        
        
    }
    
    @MainActor
    func deleteAccount() async {
        
        viewState = .loading
        
        await networkManager.deleteAccount {[weak self] result in
            switch result {
            case .success(_):
                self?.deleteStorageData()
                self?.viewState = .successDeleteAccount
                print("SUCCESS DELETE ACCOUNT")
            case .failure(let error):
                self?.viewState = .failureDeleteAccount
                print("FAILURE DELETE ACCOUNT: \(error.localizedDescription)")
            }
        }
    }
    @MainActor
    func logOut() async {
        
        viewState = .loading
        
        deleteStorageData()
        
        await networkManager.logOut { result in
            switch result {
            case .success(_):
                self.viewState = .successLogOut
                print("SUCCESS LOGOUT")
            case .failure(let error):
                self.viewState = .failureLogOut
                print("ERROR LOGOUT: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func saveAvatarImage(image:UIImage) async {
        
        viewState = .loading
        
        await networkManager.updateAvatarImage(image: image) { [weak self] result in
            switch result {
            case .success(_):
                self?.userDefaults.set(image.pngData(), forKey: .userAvatarImage)
                self?.viewState = .successSaveAvatarImage
                print("SUCCESS UPLOAD IMAGE")
            case .failure(let error):
                print("FAILURE UPLOAD IMAGE: \(error.localizedDescription)")
                self?.viewState = .failureSaveAvatarImage
            }
        }
        
    }
    
    func deleteStorageData() {
//        userDefaults.remove(forKey: .startDate)
//        userDefaults.remove(forKey: .endDate)
        
        userDefaults.remove(forKey: .status)
        userDefaults.remove(forKey: .isSavedData)
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
        
        setPresentEvents()
        
    }
    
    
}
