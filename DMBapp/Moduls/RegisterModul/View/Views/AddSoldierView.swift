//
//  AddSoldierView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 05.12.2024.
//

import SwiftUI

struct AddSoldierView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    
    
    @State var soldierName = ""
    @State var startDate:Date = .now
    @State var endDate:Date = .now.addingTimeInterval(31536000)
    
    @State var isPresentNextView = false
    
    @State var path = NavigationPath()
    
    @State var isValidData = false
    
    @FocusState var isShowKeyboard
    
    var body: some View {
        if isPresentNextView {
            CustomTabView()
        } else {
            VStack {
                VStack (alignment: .leading) {
                    Text("Добавление солдата")
                        .font(.system(size: 48))
                        .bold()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Заполните поля")
                        .foregroundStyle(Color.dmbBlack)
                        .frame(alignment: .leading)
                }
                .padding()
                
                VStack {
                    CustomDatePicker(placeholder: "Дата призыва", selectedDate: $startDate)
                    CustomDatePicker(placeholder: "Дата дембеля", selectedDate: $endDate)
                    CustomTextFiled(placeholder: "Имя солдата", text: $soldierName)
                }
                .padding()
                
                Spacer()
                
                AddSoldierButton(isActive: $isValidData) {
                    viewModel.saveTimerInStorage(startDate: startDate, endDate: endDate)
                    viewModel.saveUserName(name: self.soldierName)
                    viewModel.setPresentEvents()
                    
                    isPresentNextView = true
                }
                .padding()
                
            }
            
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .frame(maxWidth: .infinity)
            .background(Color.white.ignoresSafeArea().onTapGesture {
                self.hideKeyboard()
            })
            .onChange(of: startDate) { _ in
                withAnimation {
                    isValidData = isValid()
                }
                endDate = startDate.addingTimeInterval(31536000)
            }
            .onChange(of: endDate) { _ in
                withAnimation {
                    isValidData = isValid()
                }
            }
            .onChange(of: soldierName) { _ in
                withAnimation(.easeIn) {
                    isValidData = isValid()
                }
            }
        }
    }
    
    
    
    func isValid() -> Bool {
        return !soldierName.isEmpty &&
        startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 &&
        startDate.timeIntervalSince1970 < Date.now.timeIntervalSince1970 &&
        endDate.timeIntervalSince1970 > Date.now.timeIntervalSince1970
        
        return false
        
    }
}

#Preview {
    AddSoldierView()
}
