//
//  Double.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 30.10.2024.
//

import Foundation

extension Double {
    
    func roundedForNums(for num:Int) -> Double {
        
        var curr = self
        
        curr *= pow(10.0, Double(num))
        curr.round(.down)
        curr /= pow(10.0, Double(num))
        
        return curr
    }
    
}
