//
//  RegisterNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

extension NetworkManager: RegisterNetworkManager {
    func signUp(parametrs:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
        
        
        AF.request(url.createURL(urlComp: "/auth/sign-up"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).validate().response { response in
            completion(response)
        }
    }
    
    func signIn(parametrs:Parameters, completion:@escaping((DataResponse<Tokens, AFError>) -> ())) async {
        
        AF.request(url.createURL(urlComp: "/auth/sign-in"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
        
    }
    func sendOtpCode(parameters:Parameters)  {
        AF.request(url.createURL(urlComp: "/auth/send-otp-verification"), method: .post, parameters: parameters, encoding: JSONEncoding.default).response { _ in
            
            print("КОд отправлен")
        }
    }
    func mailConfirmation(parametrs:Parameters, completion:@escaping(DataResponse<Tokens, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/verify-email"), method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    func fetchSettings(completion:@escaping(DataResponse<Settings, AFError>) -> ())  {
        AF.request(url.createURL(urlComp: "/user/settings"), method: .get, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: Settings.self) { response in
            completion(response)
        }
    }
    
    func sendPasswordResentOtp(parameters:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        
        
        AF.request(url.createURL(urlComp: "/auth/send-password-reset-otp"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { response in
            completion(response)
        }
    }
    
    func verefyPasswordReset(parameters:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/verify-password-reset"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { response in
            completion(response)
        }
    }
    
    func resetPassword(parameters:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/reset-password"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { response in
            completion(response)
        }
    }
    
}
