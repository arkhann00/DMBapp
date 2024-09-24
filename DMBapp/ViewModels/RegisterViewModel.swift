//
//  RegisterViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.05.2024.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

class RegisterViewModel: ObservableObject {
    
    private var user:User?
    private let userDefaults = UserDefaultsManager.shared
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainManager.shared
    @Published var viewState:RegisterViewEnum = .none
    @Published var mailComfirmationState:ViewState = .none
    @Published var startDate = Date.now
    @Published var endDate = Date.now.addingTimeInterval(31536000)
    
    private let coreDataManager = CoreDataManager.shared
    
    func isDatesValid() -> Bool {
        
        return true
    }
    
    func startDateWasChanged() {
        endDate = startDate.addingTimeInterval(31536000)
    }
        
    func setSatus(status: String) {
        userDefaults.set(status, forKey: .status)
    }
    
    func setStartDate() {
        userDefaults.set(startDate, forKey: .startDate)
    }
    
    func setEndDate() {
        userDefaults.set(endDate, forKey: .endDate)
    }
    
    
    func isDataSaved() {
        userDefaults.set(true, forKey: .isSavedData)
    }
    
    func saveDemobilizationDate() {
        
//        networkManager.addEvent(parametrs: timerParametrs) { result in
//            switch result {
//            case .success(_):
//                print("SUCCESS ADD EVENT IN NETWORK")
//            case .failure(let error):
//                print("FAILURE ADD EVENT IN NETWORK: \(error.localizedDescription)")
//            }
//        }
//        coreDataManager.addEvent(text: "дембеля", date: endDate)
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    func mailConfirmation(mail:String, num:Int, avatarImage:UIImage?) {
        let parametrs:Parameters = [
        
            "email" : mail,
            "otp" : num
        
        ]
        mailComfirmationState = .loading
        networkManager.mailConfirmation(parametrs: parametrs) {[weak self] response in
            let result = response.result
            switch result {
            case .success(let auth):
                let status1 = self?.keychain.save(key: .accessToken, value: auth.accessToken)
                let status2 = self?.keychain.save(key: .refreshToken, value: auth.refreshToken)
                self?.userDefaults.set(auth.accessTokenExpiresAt, forKey: .accessTime)
                self?.userDefaults.set(auth.refreshTokenExpiresAt, forKey: .refreshTime)
                
                if status1 == errSecSuccess && status2 == errSecSuccess {
                    print("SIGN UP IS SUCCESSFUL")

                        self?.networkManager.getUserData(completion: { response in
                        let result = response.result
                        switch result {
                        case.success(let user):
                            self?.userDefaults.set(user.id, forKey: .userId)
                            self?.userDefaults.set(user.name, forKey: .userName)
                            self?.userDefaults.set(user.userType, forKey: .userType)
                            self?.userDefaults.set(user.nickname, forKey: .userNickname)
                            self?.userDefaults.set(user.login, forKey: .userLogin)
                            self?.userDefaults.set(user.avatarLink, forKey: .userAvatarImage)
                            
                            let timerParametrs = ["startTimeMillis" : Int64(((self?.userDefaults.date(forKey: .startDate)!.timeIntervalSince1970)! * 1000)) , "endTimeMillis" : Int64((((self?.userDefaults.date(forKey: .endDate)!.timeIntervalSince1970)!) * 1000)) ]
                            
                            self?.networkManager.updateTimer(parametrs: timerParametrs) { [weak self] response in
                                
                                switch response.result {
                                case .success(_):
                                    
                                    guard let image = avatarImage else {
                                        self?.mailComfirmationState = .online
                                        return
                                    }
                                    self?.networkManager.updateImage(image: image) { result in
                                        switch result {
                                        case .success(_):
                                            self?.mailComfirmationState = .online
                                        case .failure(_):
                                            print("ERROR LOAD AVATAR IMAGE")
                                        }
                                    }
                                    print("success timer update")
                                case .failure(_):
                                    self?.mailComfirmationState = .offline
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
                        case .failure(_):
                            print("ERROR FETCH USER")
                        }
                    })
                    
                }
                else {
                    self?.mailComfirmationState = .offline
                    print("SIGN UP KEYCHAIN ERROR")
                }
                
            case .failure(_):
                self?.mailComfirmationState = .offline
                print("SIGN UP ERROR: \(response)")
                if let data = response.data {
                    do { 
                        let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                        print(networkError.message)
                    } catch {
                        print("")
                    }
                }
                
            }
        }
    }
   
    func registerAccount(mail:String, password:String, name:String, nickname:String, avatarImage:UIImage?) {
            let parametrs = [
                "login" : mail,
                "password" : password,
                "name" : name,
                "nickname" : nickname
            ]
            
            viewState = .loading
            
            networkManager.signUp(parametrs: parametrs) { [weak self] response in
                switch response.result {
                case .success(let auth):
                    let _ = self?.keychain.save(key: .accessToken, value: auth.accessToken)
                    let _ = self?.keychain.save(key: .refreshToken, value: auth.refreshToken)
                    self?.userDefaults.set(auth.accessTokenExpiresAt, forKey: .accessTime)
                    self?.userDefaults.set(auth.refreshTokenExpiresAt, forKey: .refreshTime)
                    
                        print("SIGN UP IS SUCCESSFUL")
                       
                                self?.networkManager.getUserData(completion: { response in
                                    let result = response.result
                                    switch result {
                                    case.success(let user):
                                        self?.userDefaults.set(user.id, forKey: .userId)
                                        self?.userDefaults.set(user.name, forKey: .userName)
                                        self?.userDefaults.set(user.userType, forKey: .userType)
                                        self?.userDefaults.set(user.nickname, forKey: .userNickname)
                                        self?.userDefaults.set(user.login, forKey: .userLogin)
                                        self?.userDefaults.set(user.avatarLink, forKey: .userAvatarImage)
                                        
                                        let timerParametrs = ["startTimeMillis" : Int64(((self?.userDefaults.date(forKey: .startDate)!.timeIntervalSince1970)! * 1000)) , "endTimeMillis" : Int64((((self?.userDefaults.date(forKey: .endDate)!.timeIntervalSince1970)!) * 1000)) ]
                                        
                                        self?.networkManager.updateTimer(parametrs: timerParametrs) { [weak self] response in
                                            
                                            switch response.result {
                                            case .success(_):
                                                
                                                guard let image = avatarImage else {
                                                    self?.viewState = .successReg
                                                    return
                                                }
                                                self?.networkManager.updateImage(image: image) { result in
                                                    switch result {
                                                    case .success(_):
                                                        self?.viewState = .successReg
                                                    case .failure(_):
                                                        print("ERROR LOAD AVATAR IMAGE")
                                                    }
                                                }
                                                print("success timer update")
                                            case .failure(_):
                                                self?.viewState = .failureReg
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
                                    case .failure(_):
                                        self?.viewState = .failureReg
                                        print("ERROR FETCH USER")
                                    }
                                })
                            
                        
                                                           
                   
                case .failure(_):
                    if let data = response.data {
                        do {
                            let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                            switch networkError.name {
                            case "INVALID_INPUT_FORMAT":
                                self?.viewState = .invalidInputFormat
                                print(networkError.message)
                            case "NICKNAME_IS_TAKEN":
                                self?.viewState = .nicknameIsTaken
                                print(networkError.message)
                            case "ACCOUNT_ALREADY_EXISTS":
                                self?.viewState = .accountAlreadyExists
                                print(networkError.message)
                            default:
                                self?.viewState = .failureReg
                                print(networkError.message)
                            }
                        } catch {
                            self?.viewState = .failureReg
                            print(response)
                        }
                    }
                }
                
            }
            
        }
    
    func authorizationAccount(mail:String, password:String) {
            let parametrs = [
                "login" : mail,
                "password" : password
            ]
            viewState = .loading
            networkManager.signIn(parametrs: parametrs) {[weak self] response in
                
                switch response.result {
                case .success(let auth):
                    
                    let status1 = self?.keychain.save(key: .accessToken, value: auth.data.accessToken)
                    let status2 = self?.keychain.save(key: .refreshToken, value: auth.data.refreshToken)
                    self?.userDefaults.set(auth.data.accessTokenExpiresAt, forKey: .accessTime)
                    self?.userDefaults.set(auth.data.refreshTokenExpiresAt, forKey: .refreshTime)
                    
                    if status1 == errSecSuccess && status2 == errSecSuccess {
                        print("SIGN IN IS SUCCESSFUL")
                        
                        self?.networkManager.getTimer(completion: {[weak self] result in
                            switch result {
                            case .success(let timer):
                                self?.userDefaults.set(timer.startTimeMillis.convertFromInt64ToDate(), forKey: .startDate)
                                self?.userDefaults.set(timer.endTimeMillis.convertFromInt64ToDate(), forKey: .endDate)
                                print("SUCCESS GET TIMER")
                                self?.networkManager.getUserData(completion: {[weak self] response in
                                    let result = response.result
                                    switch result {
                                    case .success(let user):
                                        self?.userDefaults.set(user.id, forKey: .userId)
                                        self?.userDefaults.set(user.login, forKey: .userLogin)
                                        self?.userDefaults.set(user.name, forKey: .userName)
                                        self?.userDefaults.set(user.nickname, forKey: .userNickname)
                                        self?.userDefaults.set(user.userType, forKey: .userType)
                                        
                                        if let avatarLink = user.avatarLink {
                                            self?.networkManager.loadImage(imageURL: avatarLink, completion: { result in
                                                switch result {
                                                case .success(let imageData):
                                                    self?.userDefaults.set(imageData, forKey: .userAvatarImage)
                                                case .failure(_):
                                                    print("ERROR LOAD AVATAR IMAGE")
                                                }
                                            })
                                        }
                                        
                                        self?.networkManager.fetchSettings(completion: {[weak self] response in
                                            switch response.result {
                                            case .success(let settings):
                                                self?.userDefaults.set(settings.backgroundTint, forKey: .isBackgroundDim)
                                                if let backgroundImageLink = settings.backgroundImageLink {
                                                    self?.networkManager.loadImage(imageURL: backgroundImageLink, completion: { result in
                                                        switch result {
                                                        case .success(let imageData):
                                                            self?.userDefaults.set(imageData, forKey: .userAvatarImage)
                                                            self?.viewState = .successAuth
                                                        case .failure(_):
                                                            self?.viewState = .failureAuth
                                                            print("ERROR LOAD AVATAR IMAGE")
                                                        }
                                                    })
                                                } else {
                                                    self?.viewState = .successAuth
                                                }
                                            case .failure(_):
                                                self?.viewState = .failureAuth
                                                response.printJsonError()
                                            }
                                        })
                                        
                                    case .failure(let error):
                                        self?.viewState = .failureAuth
                                        print("FAILURE SAVE USERDEFAULTS USER DATA: \(error.localizedDescription)")
                                    }
                                })
                            case .failure(_):
                                self?.viewState = .failureAuth
                                print("ERROR GET TIMER")
                            }
                        })
                    }
                    else {
                        self?.viewState = .failureAuth
                        print("SIGN IN KEYCHAIN ERROR")
                    }
                case .failure(_):
                    if let data = response.data {
                        do {
                            let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                            switch networkError.name {
                            case "DATA_NOT_FOUND":
                                self?.viewState = .dataNotFound
                                print(networkError.message)
                            case "INCORRECT_PASSWORD":
                                self?.viewState = .incorrectPassword
                                print(networkError.message)
                            case "INVALID_INPUT_FORMAT":
                                self?.viewState = .invalidInputFormat
                                print(networkError.message)
                            default:
                                self?.viewState = .failureReg
                                print(networkError.message)
                            }
                        } catch {
                            self?.viewState = .failureReg
                            print(response)
                        }
                    }
                }
                
                
                
            }
            
        }


    
}
