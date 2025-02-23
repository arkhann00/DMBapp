//
//  RegisterNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

protocol RegisterNetworkManager {
    func signUp(parametrs:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
    func signIn(parametrs:Parameters, completion:@escaping((DataResponse<Tokens, AFError>) -> ())) async
    func sendOtpCode(parameters:Parameters)
    func mailConfirmation(parametrs:Parameters, completion:@escaping(DataResponse<Tokens, AFError>) -> ()) async
    func fetchSettings(completion:@escaping(DataResponse<Settings, AFError>) -> ()) async
}
