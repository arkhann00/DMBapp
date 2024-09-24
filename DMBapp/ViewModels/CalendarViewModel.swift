//
//  CalendarViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import Foundation
import Combine




class CalendarViewModel: ObservableObject {
    
    @Published var days:[Day] = []
    @Published var events:[Event] = []
    @Published var viewState:CalendarViewEnum = .none
    
    private let coreDataManager = CoreDataManager.shared
    private let userDefaults = UserDefaultsManager.shared
    private let networkManager = NetworkManager.shared
    
    init() {
        getArrOfMonth(date: Date.now)
        fetchEvents()
        print("calendar viewmodel init")
        
    }
    
    func getArrOfMonth(date: Date) {
        days.removeAll()
        for d in 0..<date.daysInMonth() {
            let calendar = Calendar.current
            let event = Day(id: UUID(), date: calendar.date(byAdding: .day, value: d, to: date.startOfMonth())!)
            days.append(event)
        }
       
            
    }
    
    func fetchEvents() {
        viewState = .loading
        
        networkManager.getEvents { [weak self] result in
            switch result {
            case .success(let eventsData):
                print(eventsData)
                self?.coreDataManager.removeAllEvents()
                for eventData in eventsData {
                    self?.coreDataManager.addEvent(text: eventData.title, date: eventData.timeMillis.convertFromInt64ToDate(), id: Int16(eventData.id))
                }
                self?.events = self?.coreDataManager.fetchAllEvents() ?? []
                print()
                print(self?.events)
                self?.viewState = .success
                print("SUCCESS FETCH EVENTS")
            case .failure(_):
                if let events = self?.coreDataManager.fetchAllEvents() {
                    self?.events = events
                }
                self?.viewState = .failure
                print("ERROR FETCH EVENTS")
            }
            
            
        }
    }
    
    func getCurrentDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 0, to: Date.now) ?? Date.now
    }
    
    func addNewEvent (description text:String, date:Date) {
        viewState = .loading
        let timerParametrs:[String : Any] = [
        
            "title" : text,
            "timeMillis" : date.convertDateToInt64()
        
        ]
        
        print(timerParametrs)
        
        networkManager.addEvent(parametrs: timerParametrs) {[weak self] result in
            switch result {
            case .success(_):
                self?.viewState = .success
                self?.fetchEvents()
                print("SUCCESS ADD EVENT IN NETWORK")
            case .failure(let error):
                self?.viewState = .failure
                print("FAILURE ADD EVENT IN NETWORK: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func removeEvent (_ removedEvent:Event) {
        viewState = .loading
        networkManager.deleteEvent(eventId: Int(removedEvent.eventId)) {[weak self] response in
            switch response.result {
            case .success(_):
                print("SUCCESS DELETE EVENT")
                self?.viewState = .success
                self?.fetchEvents()
            case .failure(_):
                self?.viewState = .failure
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
    
    func getPossibleEvent(date:Date) -> Int? {
        
        for i in 0..<events.count {
            if let eventDate = events[i].date, eventDate.getDateFromString() == date.getDateFromString() {
                
                return i
            }
        }
        return nil
        
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: .language) ?? "default"
    }
    
    
}
