//
//  Int64.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 01.08.2024.
//

import Foundation

extension Int64 {
    
    func convertFromInt64ToDate() -> Date {
        let timeInterval = TimeInterval(integerLiteral: self / 1000)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
}
