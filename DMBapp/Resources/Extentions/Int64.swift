//
//  Int64.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 30.10.2024.
//

import Foundation

extension Int64 {
    func convertFromInt64ToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self/1000))
    }
}
