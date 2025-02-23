//
//  CustomCalendar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import SwiftUI

struct CustomCalendar: View {
    
    @ObservedObject var viewModel:CalendarViewModel
    
    let dayOfWeek = [
        "П", "В", "С", "Ч", "П", "С", "В"
    ]
    
    var currentDate:Date
    @State var selectedDate = Date.now
    
    var body: some View {
        VStack {
            
            HStack {
                ForEach(dayOfWeek, id: \.self) { day in
                    Text("\(day)")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .font(.manrope(size: 16, weight: .medium))
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0..<currentDate.dayOfWeek()-1, id: \.self) { _ in
                    Text(" ")
                }
                ForEach(viewModel.days) { day in
                    
                    
                    Text(day.date.getOnlyDay())
                        .foregroundStyle(day.date.getDateFromString() == Date.now.getDateFromString() ? .white : .black)
                        .padding(.vertical,5)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .foregroundStyle(day.date.getDateFromString() == Date.now.getDateFromString() ? .white : .black)
                        .font(.manrope(size: 16, weight: .medium))
                        .background {
                            if day.date.getDateFromString() == Date.now.getDateFromString() {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.dmbRed)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if viewModel.getPossibleEvent(date: day.date) != nil {
                                Circle()
                                    .foregroundStyle(Color.dmbRed)
                                    .frame(width: 12, height: 12)
                                    .overlay {
                                        Image(Images.redStar())
                                            .resizable()
                                    }
                            }
                        }
                    
                }
                
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
    
}

#Preview {
    CustomCalendar(viewModel: CalendarViewModel(), currentDate: Date.now.startOfMonth())
}
