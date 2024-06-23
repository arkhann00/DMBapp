//
//  User.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.05.2024.
//

import Foundation

class User {
    
    static let shared = User()
    
    var status: String?
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isOnline: Bool = false
    
    private init(){}
    
}
