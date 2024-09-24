//
//  ChangeDateView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 18.09.2024.
//

import SwiftUI

struct ChangeDateView: View {
    
    private let userDefaults = UserDefaultsManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel:SettingsViewModel
    
    @State var startDate:Date
    @State var endDate:Date
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.startDate = userDefaults.date(forKey: .startDate) ?? Date.now
        self.endDate = userDefaults.date(forKey: .endDate) ?? Date.now
    }
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button {
                    dismiss()
                } label: {
                    Image("BlackArrow")
                        .resizable()
                        .frame(width: 23.02, height: 22)
                }
                .rotationEffect(.degrees(180))
                .padding(.leading, 26)
                .padding(.bottom, 37)
                
                Spacer()
            }
            
            Text("Настройки таймера".localize(language: viewModel.getLanguage()))
                .foregroundStyle(.black)
                .font(.custom("benzin-extrabold", size: 20))
            Rectangle()
                .frame(width: 336, height: 1)
                .padding(.top, 19)
                .padding(.bottom, 30)
                .foregroundStyle(.black)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                    .frame(width: 333,height: 128)
                    .foregroundStyle(.black)
                VStack{
                    
                    HStack {
                        Text("Дата призыва:".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 17))
                            .foregroundStyle(.black)
                        Spacer()
                        DatePick(date: $startDate)
                            .onChange(of: startDate, perform: { value in
                                endDate = startDate.addingTimeInterval(31536000)
                            })
                        
                    }
                    .frame(width: 311, height: 21)
                    Rectangle()
                        .frame(width: 310, height: 1)
                        .padding(.top, 6)
                        .foregroundStyle(.black)
                    
                    HStack {
                        Text("Дата дембеля:".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 17))
                            .foregroundStyle(.black)
                        Spacer()
                        DatePick(date: $endDate)
                        
                        
                    }
                    .frame(width: 311, height: 21)
                    Rectangle()
                        .frame(width: 310, height: 1)
                        .padding(.top, 6)
                        .foregroundStyle(.black)
                }
                
            }
            
            Button {
                viewModel.changeDates(startDate: startDate, endDate: endDate)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 193, height: 42)
                    Text("СОХРАНИТЬ".localize(language: viewModel.getLanguage()))
                        .font(.custom("benzin-extrabold", size: 20))
                        .foregroundStyle(.white)
                }
            }
            .padding(.top, 59)
            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
            if viewModel.viewState == .successSavingTimer {
                Text("Данные сохранены")
                    .foregroundStyle(.green)
                    .font(.custom("Montserrat", size: 12))
            } else if viewModel.viewState == .failureSavingTimer {
                Text("Ошибка сохранения данных")
                    .foregroundStyle(.red)
                    .font(.custom("Montserrat", size: 12))
            }
            
            
            Spacer()
            
        }
        .frame(maxHeight: .infinity)
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
        .overlay {
            ZStack {
                if viewModel.viewState == .loading {
                    CustomDimActivityIndicator()
                }
            }
        }
        
        
        
        
        
    }
}
        
         
    
#Preview {
    ChangeDateView(viewModel: SettingsViewModel())
}
