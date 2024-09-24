//
//  CustomAddButton.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import SwiftUI

struct CustomAddButton: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    var body: some View {
        
            Circle()
                .frame(width: 71)
                .foregroundStyle(Color(red: 46/255, green: 40/255, blue: 40/255))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 1-0.25), radius: 4, x: 2, y: 4)
                .overlay {
                    Text("+")
                        .font(.custom("benzin-regular", size: 49))
                        .foregroundStyle(.white)
                }
        
        
    }
}

#Preview {
    CustomAddButton()
}
