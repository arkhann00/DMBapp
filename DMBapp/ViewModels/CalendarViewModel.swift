//
//  CalendarViewModel.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import Foundation
import Combine
import RealmSwift

class CalendarViewModel: ObservableObject {

    @Published var days:[Day] = []
    @Published var events:[Event] = []
    private var realm:Realm?
    var cancellable = Set<AnyCancellable>()
    
    init() {
        getArrOfMonth(date: Date.now)
        configureRealm()
        getEvents()
    }
    
    func getArrOfMonth(date: Date) {
        days.removeAll()
        for d in 0..<date.daysInMonth() {
            let calendar = Calendar.current
            let event = Day(id: UUID(), date: calendar.date(byAdding: .day, value: d, to: date.startOfMonth())!)
            days.append(event)
        }
       
            
    }
    
    func getEvents() {
        if let eventsResult = realm?.objects(Event.self) {
            events = Array(eventsResult)
        }
    }
    
    func getCurrentDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 0, to: Date.now) ?? Date.now
    }
    
    func addNewEvent (description text:String, date:Date) {
        do {
            try realm?.write({
                let newEvent = Event()
                newEvent.date = date
                newEvent.text = text
                print(text)
                realm?.add(newEvent)
                getEvents()
            })
        } catch {
            print("ERROR ADD")
        }
    }
    
    func removeEvent (_ removedEvent:Event) {
        do {
            try realm?.write({
                realm?.delete(removedEvent)
                getEvents()
            })
        } catch {
            print("ERROR DELETE")
        }
        
    }
    
    func getPossibleEvent(date:Date) -> Int? {
        
        for i in 0..<events.count {
            if events[i].date.getDateFromString() == date.getDateFromString() {
                
                return i
            }
        }
        return nil
        
    }
    
    func configureRealm() {
        do {
            let configuration = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = configuration
            realm = try Realm()
        } catch {
            print("ERROR CONFIGURE")
        }
    }
    
}
