//
//  Event.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.06.2024.
//

import Foundation
import Combine

struct EventData: Codable, Identifiable {

    var id:Int
    var title:String
    var timeMillis:Int64
    
}
