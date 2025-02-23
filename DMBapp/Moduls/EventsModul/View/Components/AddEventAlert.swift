//
//  AddEventAlert.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 31.12.2024.
//

import SwiftUI

struct AddEventAlert: View {
    
    @ObservedObject var viewModel:CalendarViewModel
    
    @Binding var isPresented: Bool
    
    @State var title:String = ""
    @State var date:Date = .now
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Добавить событие")
                .foregroundStyle(.black)
                .font(.manrope(size: 28, weight: .bold))
            
            CustomTextFiled(placeholder: "Название события", text: $title)
            
            CustomDatePicker(placeholder: "Дата события", selectedDate: $date)
            
            RedButton(text: "Добавить событие") {
                    if !title.isEmpty {
                        viewModel.addNewEvent(description: title, date: date)
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

#Preview {
    AddEventAlert(viewModel: CalendarViewModel(), isPresented: .constant(false))
}
