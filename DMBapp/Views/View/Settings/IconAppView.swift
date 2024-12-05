//
//  IconAppView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.07.2024.
//

import SwiftUI

struct IconAppView: View {
    
    @ObservedObject var viewModel:SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                Text("Иконка приложения".localize(language: viewModel.getLanguage()))
                    .font(.custom("benzin-extrabold", size: 24))
                    .foregroundStyle(.black)
                    .padding(.bottom, 5)
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(height: 1)
          
            }
            
            HStack {
                
                Spacer()
                Button {
                    UIApplication.shared.setAlternateIconName("RedIcon")
                } label: {
                    Image("redLogo")
                        .resizable()
                        .frame(width: 50,height: 50)
                }
                Spacer()
                Button {
                    UIApplication.shared.setAlternateIconName("BlackIcon")
                } label: {
                    Image("blackLogo")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                
                Button {
                    UIApplication.shared.setAlternateIconName("WhiteIcon")
                } label: {
                    Image("whiteLogo")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }
                Spacer()
                
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    IconAppView(viewModel: SettingsViewModel())
}
