//
//  ChangeDateView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.12.2024.
//

import SwiftUI
import WidgetKit

struct ChangeDateView: View {
    
    @ObservedObject var viewModel:SettingsViewModel
    
    @Binding var path:NavigationPath
    
    @State var startDate:Date = Date.now
    @State var endDate:Date = Date.now.addingTimeInterval(31536000)
    
    @State var isPresentNextView = false
    
    @State var isErrorChangedTimer = false
    
    @State var isValidData = false
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
            VStack {
                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(Images.leadingArrow())
                            .resizable()
                            .frame(width: 20, height: 19)
                        Text("Настройки")
                            .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                VStack (alignment: .leading) {
                    Text("Настройки таймера")
                        .font(.system(size: 48))
                        .bold()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
                
                VStack(alignment: .leading) {
                    CustomDatePicker(placeholder: "Дата призыва", selectedDate: $startDate)
                    CustomDatePicker(placeholder: "Дата дембеля", selectedDate: $endDate)
                    if isErrorChangedTimer {
                        Text("Некорректные данные таймера")
                            .foregroundStyle(.red)
                            .padding(.leading)
                    }
                    if viewModel.viewState == .successSavingTimer {
                        Text("Таймер изменен")
                            .foregroundStyle(.green)
                            .padding(.leading)
                        
                    }
                }
                .padding()
                
                Spacer()
                
                RedButton(text: "Сохранить", complition: {
                    if startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
                        
                        Task {
                            await viewModel.changeDates(startDate: startDate, endDate: endDate)
                        }
                    } else {
                        isErrorChangedTimer = true
                    }
                })
                
                
                
                .padding()
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .frame(maxWidth: .infinity)
            .background(Color.white.ignoresSafeArea().onTapGesture {
                self.hideKeyboard()
            })
            .onChange(of: viewModel.viewState) { state in
                switch state {
                case .successSavingTimer:
                    WidgetCenter.shared.reloadTimelines(ofKind: "TimerWidget")
                default:
                    break
                }
            }
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
            .onAppear {
                startDate = viewModel.userDefaults.date(forKey: .startDate) ?? Date.now
                endDate = viewModel.userDefaults.date(forKey: .endDate) ?? Date.now.addingTimeInterval(31536000)
            }
            .overlay {
                if viewModel.viewState == .loading {
                    CustomProgressView()
                    
                }
            }
            .padding(.bottom)
        
        
    }
    
    func isValid() -> Bool {
            return startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 &&
            startDate.timeIntervalSince1970 < Date.now.timeIntervalSince1970 &&
            endDate.timeIntervalSince1970 > Date.now.timeIntervalSince1970
        
        
    }
}

#Preview {
    ChangeDateView(viewModel: SettingsViewModel(), path: .constant(NavigationPath()))
}
