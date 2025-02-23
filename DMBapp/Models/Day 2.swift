//
//  Day.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import Foundation

struct Day: Identifiable {
    var id: UUID
    var date:Date
    var isEvent:Bool = false
    var description:String?
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
    
}
