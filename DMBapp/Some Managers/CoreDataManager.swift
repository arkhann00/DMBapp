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
            if let error = error as NSError? {
                fatalError()
            }
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
    
    func addEvent(text:String, date:Date) {
        let context = persistedContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: context) else { return }
        let event = Event(entity: entity, insertInto: context)
        event.text = text
        event.date = date
        saveContext()
    }
    
    func fetchAllEvents() -> [Event]? {
        let context = persistedContainer.viewContext
        let fetchRequest:NSFetchRequest<Event> = Event.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteEvent(event:Event) {
        let context = persistedContainer.viewContext
        context.delete(event)
        saveContext()
    }
}
