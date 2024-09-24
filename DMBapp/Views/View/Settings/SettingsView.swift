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
    
    @State var isPresentSaveAlert = false
    
    @State var isSavedSettings = false
    
    @State var isSoonUpdate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        
                        Button {
                            if viewModel.isSettingsEditing {
                                isPresentSaveAlert = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23, height: 22)
                        }
                        .alert("СОХРАНИТЬ НАСТРОЙКИ", isPresented: $isPresentSaveAlert, actions: {
                            HStack {
                                Button("Отмена", role: .cancel) {
                                    dismiss()
                                }
                                Button("Сохранить", role: .none) {
                                    viewModel.updateSettings()
                                }
                            }
                        }, message: {
                            Text("Вы изменили настройки. Сохранить их?")
                        })
                        
                        .rotationEffect(.degrees(180))
                        
                        Spacer()
                        
                        Button {
                            if viewModel.isSettingsEditing {
                                viewModel.updateSettings()
                            }
                        } label: {
                            if viewModel.isSettingsEditing {
                                Text("СОХРАНИТЬ")
                                    .font(.custom("benzin-regular", size: 16))
                                    .foregroundStyle(.black)
                            } else {
                                Text("СОХРАНЕНО")
                                    .font(.custom("benzin-regular", size: 16))
                                    .foregroundStyle(.black)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.black)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.white)
                                                    .padding(1)
                                            }
                                            .padding(-5)
                                    }
                                
                            }
                        }
                        .disabled(!viewModel.isSettingsEditing)
                        
                    }
                    .padding(.horizontal)
                    VStack(alignment:.leading) {
                        Text("Настройки".localize(language: viewModel.getLanguage()))
                            .font(.custom("benzin-extrabold", size: 24))
                            .foregroundStyle(.black)
                            .padding(.bottom, 5)
                        
                        Rectangle()
                            .foregroundStyle(.black)
                            .frame(height: 1)
                        
                        NavigationLink {
                            DimBackgroundView(isBackgroundDim: viewModel.isBackgroundDim, viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Затемнение фона".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                            
                        }
                        .padding(.top)
                    
//                        NavigationLink {
//                            LanguageView(viewModel: viewModel)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                        .padding(.top)
                        
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
                        
                        NavigationLink {
                            ChangeDateView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Настройки таймера".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                            
                        }
                        .padding(.top)
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                }
                .padding()
                

                
            }
            .overlay {
                if viewModel.viewState == .loading {
                    CustomDimActivityIndicator()
                }
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
