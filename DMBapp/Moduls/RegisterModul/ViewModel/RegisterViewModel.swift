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

class RegisterViewModel: ViewModel {
    
    @Published var viewState:RegisterViewEnum = .none
    @Published var mailComfirmationState:EmailConfirmationEnum = .none
    @Published var startDate = Date.now
    @Published var endDate:Date = Date.now.addingTimeInterval(31536000)
    
//    override init() {
//        super.init()
//        startDate = Date().startOfCurrentDay()
//        endDate = startDate.addingTimeInterval(31536000)
//        print(startDate)
//    }
    
    

    func isDatesValid() -> Bool {
        return true
    }
    
    func startDateWasChanged() {
        endDate = startDate.addingTimeInterval(31536000)
    }
    
    func saveTimerInStorage(startDate:Date, endDate:Date) {
        userDefaults.set(startDate, forKey: .startDate)
        userDefaults.set(endDate, forKey: .endDate)
    }
    
    func saveUserName(name:String) {
        userDefaults.set(name, forKey: .userName)
    }
    
    @MainActor
    func saveTimer() async{
        viewState = .loading
        let timerParametrs = [
            "startTimeMillis" : startDate.convertDateToInt64(),
            "endTimeMillis" : endDate.convertDateToInt64()
        ]
        Task {
            await networkManager.updateTimer(parametrs: timerParametrs) {[weak self] response in
                switch response.result {
                case .success(_):
                    self?.userDefaults.set(self?.startDate, forKey: .startDate)
                    self?.userDefaults.set(self?.endDate, forKey: .endDate)
                    print("success timer update")
                    self?.viewState = .successSaveTimer
                case .failure(_):
                    self?.viewState = .failureSaveTimer
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
        }
    }
        
    
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    @MainActor
    func mailConfirmation(num:Int, avatarImage:UIImage?) async {
        let parametrs:Parameters = [
            
            "email" : userDefaults.string(forKey: .userLogin) ?? "",
            "otp" : num
            
        ]
        mailComfirmationState = .loading
        Task {
            await networkManager.mailConfirmation(parametrs: parametrs) {[weak self] response in
                let result = response.result
                switch result {
                case .success(let auth):
                    let _ = self?.keychain.save(key: .accessToken, value: auth.accessToken)
                    let _ = self?.keychain.save(key: .refreshToken, value: auth.refreshToken)
                    self?.userDefaults.set(auth.accessTokenExpiresAt, forKey: .accessTime)
                    self?.userDefaults.set(auth.refreshTokenExpiresAt, forKey: .refreshTime)
                    self?.viewState = .successEmailVerify
                    
                    
                    
                case .failure(_):
                    self?.viewState = .failureEmailVerify
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
    }
    
    func saveStatus(status:String) {
        userDefaults.set(status, forKey: .userStatus)
    }
    
    @MainActor
    func sendPasswordResetOtp(email:String) async {
        viewState = .loading
        
        let parameters:Parameters = [
            "email": email
        ]
        
        await networkManager.sendPasswordResentOtp(parameters: parameters) {[weak self] response in
            switch response.result {
            case .success(_):
                print("success sendPasswordResetOtp")
                self?.viewState = .successSendPasswordResetOtp
                self?.userDefaults.set(email, forKey: .userLogin)
            case .failure(_):
                response.printJsonError()
                self?.viewState = .failureSendPasswordResetOtp
            }
        }
        
    }
    
    @MainActor
    func sendPasswordResetOtpAgain() async {
        viewState = .loading
        
        guard let email =  userDefaults.string(forKey: .userLogin) else { return }
        
        let parameters:Parameters = [
            "email": email
        ]
        
        await networkManager.sendPasswordResentOtp(parameters: parameters) {[weak self] response in
            switch response.result {
            case .success(_):
                self?.viewState = .successEmailVerify
                print("success sendPasswordResetOtpAgain")
            case .failure(_):
                self?.viewState = .failureEmailVerify
                print("failure sendPasswordResetOtpAgain")
            }
        }
        
    }
    
    @MainActor
    func verifyPasswordResetOtp(otp:Int) async {
        viewState = .loading
        
        guard let email =  userDefaults.string(forKey: .userLogin) else { return }
        
        let parameters:Parameters = [
            "otp": otp,
            "email": email
        ]
        
        await networkManager.verefyPasswordReset(parameters: parameters) {[weak self] response in
            switch response.result {
            case .success(_):
                print("success verifyPasswordResetOtp")
                self?.viewState = .successVerifyPasswordReset
            case .failure(_):
                self?.viewState = .failureVerifyPasswordReset
                print("failure verifyPasswordResetOtp")
            }
        }
        
    }
    
    @MainActor
    func resetPassword(password:String) async {
        guard let email =  userDefaults.string(forKey: .userLogin) else { return }
        let parameters:Parameters = [
            "password" : password,
            "email" : email
        ]
        viewState = .loading
        Task {
            await networkManager.resetPassword(parameters: parameters) {[weak self] response in
                switch response.result {
                case .success(_):
                    print("success resetPassword")
                    self?.viewState = .successPasswordReset
                case .failure(_):
                    self?.viewState = .failurePasswordReset
                    print("failure resetPassword")
                }
            }
        }
    }
    
    
    @MainActor
    func sendCodeToEmail() async {
        guard let email =  userDefaults.string(forKey: .userLogin) else { return }
        let parameters:Parameters = [
            "email" : email
        ]
        Task {
            await networkManager.sendOtpCode(parameters: parameters)
        }
    }
    
    @MainActor
    func registerAccount(mail:String, password:String, nickname:String) async {
        print(1)
        let parametrs = [
            "login" : mail,
            "password" : password,
            "nickname" : nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            "userType" : "OTHER"
        ]
        
        viewState = .loading
        Task {
        await networkManager.signUp(parametrs: parametrs) { [weak self] response in
            print(2)
            switch response.result {
            case .success(_):
                self?.viewState = .successReg
                self?.userDefaults.set(mail, forKey: .userLogin)
                self?.userDefaults.set(nickname, forKey: .userNickname)
                print(3.1)
            case .failure(_):
                print(3.2)
                self?.viewState = .failureReg
                print(response)
                if let data = response.data {
                    
                        switch response.response?.statusCode {
                        case 400:
                            do {
                                
                                let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                            switch networkError.name {
                            case "MISSING_REQUEST_FIELD":
                                self?.viewState = .missingRequestField
                            case "EMPTY_FIELD":
                                self?.viewState = .emptyField
                            case "INVALID_INPUT_FORMAT":
                                self?.viewState = .invalidInputFormat
                            default:
                                self?.viewState = .failureReg
                            }
                            } catch {
                                self?.viewState = .failureReg
                            }
                        case 409:
                            do {
                                
                                let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                            switch networkError.name {
                            case "NICKNAME_IS_TAKEN":
                                self?.viewState = .nicknameIsTaken
                            case "ACCOUNT_ALREADY_EXISTS":
                                self?.viewState = .accountAlreadyExists
                            default:
                                self?.viewState = .failureReg
                            }
                            } catch {
                                self?.viewState = .failureReg
                            }
                            
                        case 500:
                            self?.viewState = .databaseError
                            print("databaseError")
                        default:
                            self?.viewState = .failureReg
                            print("failureReg")
                        }
                     response.printJsonError()
                    }
                }
            }
            
        }
        
    }
    
    @MainActor
    func authorizationAccount(mail:String, password:String) async {
        let parametrs = [
            "login" : mail,
            "password" : password
        ]
        viewState = .loading
        Task {
            await networkManager.signIn(parametrs: parametrs) {[weak self] response in
                
                switch response.result {
                case .success(let auth):
                    
                    let status1 = self?.keychain.save(key: .accessToken, value: auth.accessToken)
                    let status2 = self?.keychain.save(key: .refreshToken, value: auth.refreshToken)
                    self?.userDefaults.set(auth.accessTokenExpiresAt, forKey: .accessTime)
                    self?.userDefaults.set(auth.refreshTokenExpiresAt, forKey: .refreshTime)
                    
                    if status1 != nil && status2 != nil{
                        print("SIGN IN IS SUCCESSFUL")
                        
                        self?.networkManager.getTimer(completion: {[weak self] result in
                            switch result {
                            case .success(let timer):
                                self?.userDefaults.set(timer.startTimeMillis.convertFromInt64ToDate(), forKey: .startDate)
                                self?.userDefaults.set(timer.endTimeMillis.convertFromInt64ToDate(), forKey: .endDate)
                                print("SUCCESS GET TIMER")
                                self?.networkManager.getEvents(completion: { result in
                                    switch result {
                                    case .success(let eventsData):
                                        print(eventsData)
                                        self?.coreDataManager.removeAllEvents()
                                        for eventData in eventsData {
                                            self?.coreDataManager.addEvent(text: eventData.title, date: eventData.timeMillis.convertFromInt64ToDate(), id: eventData.id)
                                        }
                                        print("SUCCESS FETCH EVENTS")
                                    case .failure(_):
                                        
                                        self?.viewState = .failureAuth
                                        print("ERROR FETCH EVENTS")
                                    }
                                    
                                    self?.networkManager.getUserData(completion: {[weak self] response in
                                        let result = response.result
                                        switch result {
                                        case .success(let user):
                                            self?.userDefaults.set(user.id, forKey: .userId)
                                            self?.userDefaults.set(user.login, forKey: .userLogin)
                                            self?.userDefaults.set(user.nickname, forKey: .userNickname)
                                            self?.userDefaults.set(user.login, forKey: .userLogin)
                                            self?.userDefaults.set(user.isAdmin, forKey: .isAdminUser)
                                            print(user)
                                            print(self?.userDefaults.bool(forKey: .isAdminUser))
                                            
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
                                                                self?.userDefaults.set(imageData, forKey: .backgroundImage)
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
                        print(response.response?.statusCode)
                        
                            
                            switch response.response?.statusCode {
                            case 400:
                                do {
                                    let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                                    switch networkError.name {
                                    case "MISSING_REQUEST_FIELD":
                                        self?.viewState = .missingRequestField
                                    case "EMPTY_FIELD":
                                        self?.viewState = .emptyField
                                    case "INVALID_INPUT_FORMAT":
                                        self?.viewState = .invalidInputFormat
                                    default:
                                        self?.viewState = .failureAuth
                                    }
                                } catch {
                                    self?.viewState = .failureAuth
                                    print("failureAuth")
                                }
                            case 401:
                                self?.viewState = .incorrectPassword
                                print("incorrectPassword")
                            case 403:
                                self?.viewState = .accountNotVerified
                                print("accountNotVerified")
                            case 404:
                                self?.viewState = .dataNotFound
                                print("dataNotFound")
                            case 500:
                                self?.viewState = .databaseError
                                print("databaseError")
                            
                            default:
                                self?.viewState = .failureAuth
                                print("failureAuth")
                            }
                        
                    }
                }
                
            }
            
        }
        
    }
    
}


    

