//
//  TimeNumber.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.12.2024.
//

import SwiftUI

struct TimeTextFild: View {
    
    var number:Int
    @State var time:String
    
    init(number:Int, time:Time) {
        self.number = number
        
        switch time {
        case .seconds:
            self.time = "секунд"
        case .minutes:
            self.time = "минут"
        case .hours:
            self.time = "часа"
        case .days:
            self.time = "дней"
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Text("\(number)")
                .foregroundStyle(.white)
                .font(.manrope(size: UIScreen.main.bounds.width * 0.060, weight: .bold))
                .scaledToFit()
            Text(time)
                .foregroundStyle(.white)
                .opacity(0.5)
                .font(.manrope(size: UIScreen.main.bounds.width * 0.021, weight: .regular))
                .padding(.trailing)
                .scaledToFit()
        }
    }
    
    enum Time {
        case seconds
        case minutes
        case hours
        case days
    }
    
}

#Preview {
    TimeTextFild(number: 40, time: .minutes)
}
