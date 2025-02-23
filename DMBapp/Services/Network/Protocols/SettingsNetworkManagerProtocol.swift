//
//  SettingsNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

protocol SettingsNetworkManager {
    func updateSettings(parameters:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
    func updateTimer(parametrs:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async
}
