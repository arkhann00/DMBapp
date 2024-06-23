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
                        NavigationLink {
                            
                            CustomTabBar()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23, height: 22)
                        }
                        .padding(.horizontal)
                        
                    }
                    VStack(alignment:.leading) {
                        Text("Настройки")
                            .font(.custom("benzin-extrabold", size: 24))
                            .foregroundStyle(.black)
                            .padding(.bottom, 5)
                        
                        Rectangle()
                            .foregroundStyle(.black)
                            .frame(height: 1)
                        
                        NavigationLink {
                            DimBackgroundView(isBackgroundDim: viewModel.getBackgroundState())
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Затемнение фона")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                            
                        }
                        .padding(.top,8)
                        
                        Button {
                            isSoonUpdate = true
                        } label: {
                            Text("Анимация фона")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top, 8)
                        
                        NavigationLink {
                            LanguageView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Язык")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-regular", size: 16))
                        }
                        .padding(.top, 8)
                        
                        
                        
                        Spacer()
                    }
                    .frame(width: 308)
                }
                .alert("СКОРО", isPresented: $isSoonUpdate) {
                    Button("OK", role: .cancel, action: {})
                } message: {
                    Text("Анимации будут скоро")
                }

                
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
