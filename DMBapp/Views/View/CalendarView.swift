//
//  CalendarView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Rectangle()
                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                        .frame(height: 250)
                        .ignoresSafeArea()
                    Spacer()
                }
                VStack {
                    Spacer()
                    CustomCalendar(viewModel: viewModel)
                    EventsList(viewModel: viewModel)
                        
                }
            }
        }
        .onAppear(perform: {
            viewModel.fetchEvents()
        })
    }
}

#Preview {
    CalendarView()
}
