//
//  NetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    var keychain:KeychainManager { get }
    var url:UrlLink{ get }
    
    func getHeaders(token:String) -> HTTPHeaders
    func updateTokens(completion:@escaping(DataResponse<Tokens,AFError>) -> ()) async
    func setStatusOnline(completion:@escaping(Result<Data?, AFError>) -> ()) async
    func setStatusOffline(completion:@escaping(Result<Data?, AFError>) -> ()) async
    func fetchImage(completion:@escaping(Result<AvatarImage, AFError>) -> ()) async
    func loadImage(imageURL:String, completion:@escaping(Result<Data, AFError>) -> ())
    
}
