//
//  Int.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import Foundation

extension Int {
    
    func formatDateInTuple() -> (Int,Int,Int,Int) {
        
        let days = self/60/60/24
        let hours = self/60/60%24
        let minutes = self/60%60%24
        let seconds = self%60%60%24
        
        return (days,hours,minutes,seconds)
        
    }
    
}
