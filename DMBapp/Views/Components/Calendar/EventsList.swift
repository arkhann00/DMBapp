//
//  EventsList.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.06.2024.
//

import SwiftUI

struct EventsList: View {
    
    @EnvironmentObject var viewModel:CalendarViewModel
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                ScrollView {
                    
                    ForEach(viewModel.events) { event in

                        EventSheetView(daysLeft: Int((event.date?.timeIntervalSince(Date.now))!)/60/60/24, description: event.text!, date: event.date!)
                            .overlay {
                                Menu {
                                    Button {
                                        withAnimation(.default) {
                                            viewModel.removeEvent(event)
                                        }
                                        
                                    } label: {
                                        Text("Удалить")
                                    }

                                } label: {
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                }

                            }
                    }
                }
                
            }
            .overlay(alignment: .trailing) {
                NavigationLink {
                    NewEventView()
                        .navigationBarBackButtonHidden()
                } label: {
                    CustomAddButton()
                        .padding()
                }
                
            }
        }
    }
}


struct EventSheetView: View {
    
    @State var daysLeft:Int
    @State var description: String
    @State var date:Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(maxWidth: .infinity)
                .frame(height: 66)
                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 1-0.25), radius: 4, x: 0, y: 4)
            HStack {
                Image("WhiteArrow")
                    .resizable()
                    .frame(width: 40, height: 43)
                    .padding()
                VStack(alignment: .leading) {
                    
                        TextField("", text: .constant("\(daysLeft) дней до \(description)"))
                            .disabled(true)
                            .font(.custom("benzin-extrabold", size: 12))
                            .frame(minWidth: 200, maxWidth: .infinity)
                            .foregroundStyle(.white)
                        Spacer()
                    
                    TextField("", text: .constant(date.getFullDateAsString()))
                        .padding(.top, -10)
                        .font(.custom("Montserrat", size: 9))
                        .disabled(true)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: 43)
                
                
            }
        }
        .padding(2)
    }
}

#Preview {
    EventsList()
        .environmentObject(CalendarViewModel())
}
