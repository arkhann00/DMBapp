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
    
    @State var isSoonUpdate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Button { dismiss() } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23, height: 22)
                        }
                        .padding(.horizontal)
                        
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
                        .padding(.top,8)
                    
                        NavigationLink {
                            LanguageView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Язык".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top, 8)
                        
                        NavigationLink {
                            IconAppView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Иконка приложения".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top, 8)
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
