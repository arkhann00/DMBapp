//
//  Event.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.06.2024.
//

import Foundation
import Combine
import RealmSwift

class Event: Object, ObjectKeyIdentifiable {

    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var date:Date = Date.now
    @Persisted var text:String = ""
    
}
