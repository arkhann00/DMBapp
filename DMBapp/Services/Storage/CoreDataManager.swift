//
//  CoreDataManager.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.06.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var persistedContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
//            if let error = error as NSError? {
//                fatalError()
//            }
        }
        return container
    }()
    
    var context:NSManagedObjectContext!

    private init() {
        context = persistedContainer.viewContext
    }
    
    
    func saveContext() {
        let context = persistedContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addEvent(text:String, date:Date, id:String) {
        let context = persistedContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: context) else { return }
        let event = Event(entity: entity, insertInto: context)
        event.text = text
        event.date = date
        event.eventId = id
        saveContext()
    }
    
    func editEvent(id: ObjectIdentifier, newText: String?, newDate: Date?) {
        let context = persistedContainer.viewContext
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "eventId == %@", id as! CVarArg)

        do {
            if let event = try context.fetch(fetchRequest).first {
                // Обновляем свойства, если они переданы
                if let newText = newText {
                    event.text = newText
                }
                if let newDate = newDate {
                    event.date = newDate
                }
                saveContext()
            } else {
                print("Event with id \(id) not found.")
            }
        } catch let error {
            print("Failed to fetch event for editing: \(error.localizedDescription)")
        }
    }
    
    func fetchAllEvents() -> [Event]? {
        let context = persistedContainer.viewContext
        let fetchRequest:NSFetchRequest<Event> = Event.fetchRequest()
        do {
            let events:[Event] = try context.fetch(fetchRequest)
            return sortEvents(for: events)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func sortEvents(for events:[Event]) -> [Event] {
        var newEvents = events
        guard !events.isEmpty else { return events }
        for i in 0 ..< newEvents.count-1 {
            for j in i ..< newEvents.count {
                if Double(newEvents[i].date?.timeIntervalSince1970 ?? 1e9) > Double(newEvents[j].date?.timeIntervalSince1970 ?? 1e9) {
                    let a = newEvents[i]
                    newEvents[i] = newEvents[j]
                    newEvents[j] = a
                }
            }
        }
        return newEvents
    }
    
    func deleteEvent(event:Event) {
        let context = persistedContainer.viewContext
        context.delete(event)
        saveContext()
    }
    
    func removeAllEvents() {
        let events = fetchAllEvents() ?? []
        for event in events {
            deleteEvent(event: event)
        }
    }
}
