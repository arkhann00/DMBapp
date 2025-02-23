//
//  Font.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 27.12.2024.
//

import Foundation
import SwiftUI

extension Font {
    
    static func manrope(size:CGFloat, weight:Weight? = nil) -> Font {
        
        switch weight {
        case .ultraLight:
            return .custom("Manrope-ExtraLight.ttf", size: size)
        case .light:
            return .custom("Manrope-Light.ttf", size: size)
        case .bold:
            return .custom("Manrope-Bold", size: size)
        case .regular:
            return .custom("Manrope-Regular.ttf", size: size)
        case .medium:
            return .custom("Manrope-Medium.ttf", size: size)
        case .semibold:
            return .custom("Manrope-SemiBold.ttf", size: size)
        case .heavy:
            return .custom("Manrope-ExtraBold.ttf", size: size)
        default:
            return .custom("Manrope-Regular.ttf", size: size)
        }
        
    }
    
}
