//
//  SignUpView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.12.2024.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    
    @State var nickName = ""
    @State var mail = ""
    @State var password = ""
    
    @State var isNickNameValid = true
    @State var isMail = true
    @State var isPassword = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Button {
                dismiss()
            } label: {
                Image(Images.leadingArrow())
                    .resizable()
                    .frame(width: 12, height: 12)
                Text("Назад")
                    .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
            }
            
            Text("Создать аккаунт")
                .foregroundStyle(.black)
                .font(.system(size: 48, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width/2)
            Spacer()
            
            CustomTextFiled(placeholder: "Ник", text: $nickName, isError: isNickNameValid)
            CustomTextFiled(placeholder: "E-mail", text: $nickName, isError: isMail)
            CustomTextFiled(placeholder: "Пароль", text: $nickName, isError: isPassword)
            
            Button {
                Task {
                    await viewModel.registerAccount(mail: mail, password: password, nickname: nickName)
                }
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbRed())
                    .frame(height: 61)
                    .overlay {
                        Text("Зарегистрироваться")
                            .foregroundStyle(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            NavigationLink {
                
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbWhite())
                    .frame(height: 61)
                    .overlay {
                        Text("Уже есть аккаунт")
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            
            Spacer()
            Spacer()
        }
        .overlay(content: {
            if viewModel.viewState == .loading {
                
            }
        })
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .onChange(of: nickName) { val in
            
            
            
        }   
        
    }
}

#Preview {
    SignUpView()
}
