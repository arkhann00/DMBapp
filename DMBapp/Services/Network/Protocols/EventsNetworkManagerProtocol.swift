//
//  EventNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire

protocol EventsNetworkManager {
    func getEvents(completion:@escaping(Result<[EventData], AFError>) -> ())
    func addEvent(parametrs:Parameters, completion:@escaping(Result<EventData, AFError>) -> ()) async
    func editEvent(eventId:String, parametrs:Parameters, completion:@escaping(DataResponse<EventData, AFError>) -> ()) async
    func deleteEvent(eventId:String, completion:@escaping(DataResponse<Data?, AFError>) -> ()) async
}
