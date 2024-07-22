//
//  LanguageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.06.2024.
//

import SwiftUI

struct LanguageView: View {
    
    @ObservedObject var viewModel:SettingsViewModel
    
    @State var isAlertPresented = false
    @Environment(\.dismiss) var dismiss
    @State var currentLanguage:String
    
    init(viewModel:SettingsViewModel) {
        currentLanguage = viewModel.getLanguage()
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23, height: 22)
                    }
                    .padding(.horizontal)
                    
                }
                VStack(alignment:.leading) {
                    Text("Язык".localize(language: viewModel.getLanguage()))
                        .font(.custom("benzin-extrabold", size: 24))
                        .foregroundStyle(.black)
                        .padding(.bottom, 5)
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(height: 1)
              
                }
                .padding()
                
                Button {
                    currentLanguage = "russian"
                    viewModel.changeLanguage(language: "russian")
                } label: {
                    Text("Русский")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        .background {
                            if currentLanguage == "russian" || currentLanguage == "default" {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.white)
                                    .border(.black, width: 1)
                                    .padding(-6)
                            }
                        }
                }
                .padding()
                Button {
                    currentLanguage = "english"
                    viewModel.changeLanguage(language: "english")
                } label: {
                    Text("English")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        .background {
                            if currentLanguage == "english" {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.white)
                                    .border(.black, width: 1)
                                    .padding(-6)
                            }
                        }
                        
                }
                .alert("СКОРО", isPresented: $isAlertPresented) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("OK")
                    }

                }

                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LanguageView(viewModel: SettingsViewModel())
}
