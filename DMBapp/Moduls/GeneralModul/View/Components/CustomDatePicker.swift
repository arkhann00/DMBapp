//
//  CustomDatePicker.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 07.12.2024.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @State var placeholder:String
    @State var dateForm = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ru")
            return formatter
        }
    @Binding var selectedDate:Date
    var body: some View {
        
        HStack {
            
            Text(placeholder)
                .foregroundStyle(Color.dmbBlack)
            
            Spacer()
            
            Text((selectedDate != nil ? selectedDate.getFullDateAsString() : "Введите дату") ?? Date.now.getFullDateAsString())
                .foregroundStyle(.black)
                .overlay {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .blendMode(.destinationOver)
                }
            
            
            
            
            
        }
        
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(content: {
            RoundedRectangle(cornerRadius: 16)
                .stroke(selectedDate != nil ? Color.dmbBlack : Color.dmbRed)
        })
        .background {
            Color.white.ignoresSafeArea()
        }
    }
}

#Preview {
    CustomDatePicker(placeholder: "123123", selectedDate: .constant(Date.now))
}
