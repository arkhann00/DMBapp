//
//  Date.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import Foundation

extension Date {
    
    func daysBetweenDate(from startDate: Date,to endDate: Date, calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.day], from: startDate, to: endDate).day!
    }
    
    func getDateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let date = dateFormatter.date(from: dateFormatter.string(from: self)) else { return Date.now }
        return date
    }
    
    func getOnlyDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    func getMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL yyyy"
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter.string(from: self)
    }
    
    func getFullDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter.string(from: self)
    }
    
    func plusMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self)!
    }
    
    func minusMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self)!
    }
    

    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
        
    }
        
        
    func endOfMonth() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return calendar.date(byAdding: components, to: startOfMonth())!
        
    }
        
        
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
        
    }
    
    func dayOfWeek() -> Int {
        let calendar = Calendar.current
        let daysInUSA = calendar.component(.weekday, from: self)
        if daysInUSA == 1 {
            return 7
        }
        else {
            return daysInUSA - 1
        }
    }
    
    
    
    
}
