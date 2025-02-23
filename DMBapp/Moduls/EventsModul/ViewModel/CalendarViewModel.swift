//
//  CalendarViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import Foundation
import Alamofire

class CalendarViewModel: ViewModel {
    
    @Published var days:[Day] = []
    @Published var events:[Event] = []
    @Published var viewState:CalendarViewEnum = .none
    

    
    override init() {
        super.init()
        getArrOfMonth(date: Date.now)
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
        events = coreDataManager.fetchAllEvents() ?? []
        viewState = .success
    }
    
    func getCurrentDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 0, to: Date.now) ?? Date.now
    }
    
    func addNewEvent (description text:String, date:Date) {
        
        
            
            if self.isAuthorizedUser() {
                viewState = .loading
                let timerParametrs:Parameters = [
                    "title" : text,
                    "timeMillis" : date.convertDateToInt64()
                ]
                Task {
                    await networkManager.addEvent(parametrs: timerParametrs) {[weak self] result in
                        switch result {
                        case .success(let eventData):
                            self?.viewState = .success
                            self?.coreDataManager.addEvent(text: eventData.title, date: eventData.timeMillis.convertFromInt64ToDate(), id: eventData.id)
                            self?.fetchEvents()
                            print("SUCCESS ADD EVENT IN NETWORK")
                        case .failure(let error):
                            self?.viewState = .failure
                            print("FAILURE ADD EVENT IN NETWORK: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                self.coreDataManager.addEvent(text: text, date: date, id: "")
                self.fetchEvents()
            }
            
        
    }
    
    func editEvent(event:Event) {
        
        if event.eventId == "1" || event.eventId == "2" || event.eventId == "3" || event.eventId == "4" || event.eventId == "5" || event.eventId == "6" || event.eventId == "7" || event.eventId == "8" || event.eventId == "9" || event.eventId == "10" || event.eventId == "11" || event.eventId == "12" {
            
        } else {
            
            
            
            if isAuthorizedUser() {
                viewState = .loading
                let timerParametrs:Parameters = [
                    "title" : event.text ?? "",
                    "timeMillis" : event.date
                ]
                Task {
                    await networkManager.editEvent(eventId: event.eventId ?? "",parametrs: timerParametrs) {[weak self] response in
                        switch response.result {
                        case .success(let eventData):
                            self?.viewState = .success
                            self?.coreDataManager.editEvent(id: event.id, newText: event.text, newDate: event.date)
                            self?.fetchEvents()
                            print("SUCCESS EDIT EVENT IN NETWORK")
                        case .failure(let error):
                            self?.viewState = .failure
                            print("FAILURE EDIT EVENT IN NETWORK: \(response)")
                        }
                    }
                }
            } else {
                self.coreDataManager.editEvent(id: event.id, newText: event.text, newDate: event.date)
                self.fetchEvents()
            }
        }
        
        
    }
    
    func removeEvent(removedEvent:Event) {
        viewState = .loading
        guard let eventId = removedEvent.eventId else {
            viewState = .failure
            print("ERRRORRRR")
            print(removedEvent.id)
            return
        }
        if isAuthorizedUser() {
            Task {
                await networkManager.deleteEvent(eventId: eventId) {[weak self] response in
                    switch response.result {
                    case .success(_):
                        print("SUCCESS DELETE EVENT")
                        self?.viewState = .success
                        self?.coreDataManager.deleteEvent(event: removedEvent)
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
        } else {
            self.coreDataManager.deleteEvent(event: removedEvent)
            self.fetchEvents()
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
