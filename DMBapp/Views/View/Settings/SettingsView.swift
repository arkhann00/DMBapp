//
//  SettingsView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = SettingsViewModel()
    
    @State var isPresentAlert = false
    
    @State var isSoonUpdate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        
                        Button { dismiss() } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23, height: 22)
                        }
                        .padding(.horizontal)
                        .rotationEffect(.degrees(180))
                        
                        Spacer()
                        
                    }
                    VStack(alignment:.leading) {
                        Text("Настройки".localize(language: viewModel.getLanguage()))
                            .font(.custom("benzin-extrabold", size: 24))
                            .foregroundStyle(.black)
                            .padding(.bottom, 5)
                        
                        Rectangle()
                            .foregroundStyle(.black)
                            .frame(height: 1)
                        
                        NavigationLink {
                            DimBackgroundView(isBackgroundDim: viewModel.getBackgroundState(), viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Затемнение фона".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                            
                        }
                        .padding(.top)
                    
                        NavigationLink {
                            LanguageView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Язык".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top)
                        
//                        NavigationLink {
//                            IconAppView(viewModel: viewModel)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            Text("Иконка приложения".localize(language: viewModel.getLanguage()))
//                                .foregroundStyle(.black)
//                                .font(.custom("benzin-regular", size: 16))
//                        }
//                        .padding(.top, 8)
                        
                        Button {
                            isPresentAlert = true
                        } label: {
                            Text("Сброс заднего фона".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top)
                        .alert("Вы уверены, что хотите это сделать", isPresented: $isPresentAlert) {
                            Button("Отмена", role: .cancel) {}
                            Button("Да", role: .none) {
                                viewModel.removeBackground()
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                }
                .padding()
                

                
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
