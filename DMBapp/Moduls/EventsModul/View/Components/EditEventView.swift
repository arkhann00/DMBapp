//
//  EditEventView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 07.01.2025.
//

import SwiftUI

struct EditEventView: View {
    
    @ObservedObject var viewModel:CalendarViewModel
    
    @Binding var isPresented: Bool
    var event:Event
    
    @State var title:String = ""
    @State var date:Date = .now
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Редактировать событие")
                .foregroundStyle(.black)
                .font(.manrope(size: 28, weight: .bold))
            
            CustomTextFiled(placeholder: "Название события", text: $title)
            
            CustomDatePicker(placeholder: "Дата события", selectedDate: $date)
            
            RedButton(text: "Редактировать событие") {
                if !title.isEmpty {
                    if let eventId = event.eventId, let text = event.text, let date = event.date {
                        viewModel.editEvent(event: event)
                    }
                    
                }
                
                withAnimation {
                    isPresented = false
                }
                
            }
            .padding(.top)
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(.white)
        }
        .padding()
        .background {
            Color.black.ignoresSafeArea().frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height).opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
        }
        
    }
}
