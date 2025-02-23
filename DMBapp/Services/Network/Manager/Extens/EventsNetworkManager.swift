//
//  EventsNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

extension NetworkManager: EventsNetworkManager {
    func getEvents(completion:@escaping(Result<[EventData], AFError>) -> ()) {
        
        AF.request(url.createURL(urlComp: "/event"), encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: [EventData].self) { response in
            completion(response.result)
        }
        
    }
    
    func addEvent(parametrs:Parameters, completion:@escaping(Result<EventData, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/event"), method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: EventData.self) { response in
            completion(response.result)
        }
        
    }
    
    func editEvent(eventId:String, parametrs:Parameters, completion:@escaping(DataResponse<EventData, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/event/\(eventId)"), method: .put, parameters: parametrs, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).responseDecodable(of: EventData.self) { response in
            completion(response)
        }
        
    }
    
    
    func deleteEvent(eventId:String, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async {
        
        AF.request(url.createURL(urlComp: "/event/\(eventId)"), method: .delete, encoding: JSONEncoding.default, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response)
        }
        
    }
    
    
}
