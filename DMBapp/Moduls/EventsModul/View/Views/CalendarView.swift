//
//  CalendarView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject var viewModel = CalendarViewModel()
    
    @Binding var path:NavigationPath
    
    @State var isPresentAddEventAlert = false
    @State var isPresentEditEventAlert = false
    
    @State var tabBar = "menu"
    
    @State var currentDate = Date.now.startOfMonth()
    
    @State var editEvent: Event?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            VStack {
                    VStack (alignment: .leading) {
                        Button {
                            if tabBar == "menu" {
                                path.removeLast()
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(Images.leadingArrow())
                                .resizable()
                                .frame(width: 20, height: 19)
                            Text("Назад")
                                .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                        }
                        
                        Text("Календарь")
                            .font(.system(size: 48, weight: .bold))
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .foregroundStyle(.black)
                            .padding(.bottom, -8)
                    }
                    .frame(maxWidth: .infinity)
                    ScrollView(showsIndicators: false) {
                        Text("\(currentDate.getOnlyMonthLikeString()), \(String(currentDate.getOnlyYear()))")
                            .font(.manrope(size: 18, weight: .semibold))
                            .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                            .padding(.bottom)
                            
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomCalendar(viewModel: viewModel, currentDate: currentDate)
                            .gesture(
                                
                                DragGesture()
                                    .onEnded { value in
                                        
                                        if value.translation.width < -10 {
                                            
                                            updateArrOfDays(isPlusMonth: true)
                                        } else if value.translation.width > 10 {
                                            // Свайп вниз
                                            updateArrOfDays(isPlusMonth: false)
                                        } else {
                                            print("Свайп не распознан")
                                        }
                                    }
                            )
                        Spacer()
                        
                        ForEach(viewModel.events) { event in
                            EventCell(event: event)
                                .contextMenu(menuItems: {
                                    
                                    Button {
                                        viewModel.removeEvent(removedEvent: event)
                                    } label: {
                                        Text("Удалить")
                                    }
//                                    Button {
//                                        editEvent = event
//                                        isPresentEditEventAlert = true
//                                    } label: {
//                                        Text("Редактировать")
//                                    }
                                })
                        }
                        
                    }
                
            }
            .padding()
            Spacer()
            RedButton(text: "Добавить событие") {
                withAnimation {
                    isPresentAddEventAlert = true
                }
                
            }
            .padding(.horizontal)
        }
        .background {
            Color.white
                .ignoresSafeArea()
            
        }
        .onAppear {
            viewModel.fetchEvents()
        }
        .onChange(of: viewModel.events) { _ in
            viewModel.fetchEvents()
        }
        .overlay {
            if isPresentAddEventAlert {
                AddEventAlert(viewModel: viewModel, isPresented: $isPresentAddEventAlert)
            }
            if isPresentEditEventAlert {
                if let editEvent = editEvent {
                    EditEventView(viewModel: viewModel, isPresented: $isPresentEditEventAlert, event: editEvent, title: editEvent.text ?? "", date: editEvent.date ?? Date.now)
                }
            }
        }
        .padding(.bottom, 30)
    }
    
    func updateArrOfDays(isPlusMonth:Bool) {
        withAnimation {
            currentDate = isPlusMonth ? currentDate.plusMonth() : currentDate.minusMonth()
            viewModel.getArrOfMonth(date: currentDate)
        }
        
        
    }
    
}

#Preview {
    CalendarView(path: .constant(NavigationPath()))
}
