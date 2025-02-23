//
//  SettingsNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

extension NetworkManager: SettingsNetworkManager {
    func updateSettings(parameters:Parameters, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/user/settings"),method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
        
    }
    func updateTimer(parametrs:Parameters, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/timer"), method: .put, parameters:parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response{ response in
            completion(response)
        }
    }
    func updateBackgroundImage(imageData:Data, completion:@escaping(DataResponse<Data?,AFError>) -> ()) async {
       
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/background-image"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
    }
}
