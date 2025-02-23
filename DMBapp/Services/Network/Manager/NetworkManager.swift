//
//  NetworkManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.07.2024.
//

import Foundation
import Alamofire
import SwiftUI
import AnyCodable

class NetworkManager: NetworkManagerProtocol {
    
    let keychain = KeychainManager.shared
    let url:UrlLink = .prodServer
    
    func getHeaders(token:String) -> HTTPHeaders {
        
        var headers:HTTPHeaders {
            var headers:HTTPHeaders = []
            headers.add(name: "Authorization", value: token)
            
            return headers
            
        }
        return headers
        
    }
    
    func updateTokens(completion:@escaping(DataResponse<Tokens,AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/auth/refresh-token"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .refreshToken) ?? "")).responseDecodable(of: Tokens.self) { response in
            completion(response)
        }
    }
    
    func setStatusOnline(completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/set-status-online"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
    func setStatusOffline(completion:@escaping(Result<Data?, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/set-status-offline"), method: .put, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    func fetchImage(completion:@escaping(Result<AvatarImage, AFError>) -> ()) async {
        AF.request(url.createURL(urlComp: "/user/avatar"), headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: AvatarImage.self) { response in
                completion(response.result)
            }
    }
    
    func loadImage(imageURL:String, completion:@escaping(Result<Data, AFError>) -> ()) {
        AF.request(imageURL).responseData { response in
            completion(response.result)
        }
    }

}   
