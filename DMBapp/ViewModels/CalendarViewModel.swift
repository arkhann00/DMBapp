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
    
    private let coreDataManager = CoreDataManager.shared
    
    
    init() {
        getArrOfMonth(date: Date.now)
        fetchEvents()
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
    }
    
    func getCurrentDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 0, to: Date.now) ?? Date.now
    }
    
    func addNewEvent (description text:String, date:Date) {
        coreDataManager.addEvent(text: text, date: date)
        fetchEvents()
    }
    
    func removeEvent (_ removedEvent:Event) {
        
        coreDataManager.deleteEvent(event: removedEvent)
        fetchEvents()
    }
    
    func getPossibleEvent(date:Date) -> Int? {
        
        for i in 0..<events.count {
            if events[i].date!.getDateFromString() == date.getDateFromString() {
                
                return i
            }
        }
        return nil
        
    }
    
   
    
}
