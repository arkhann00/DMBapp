//
//  ChangePasswordView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.01.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var isErrorSendResentPasswordOpt = false
    
    @State var email = ""
    
    var body: some View {
        
        VStack {
            VStack (alignment: .leading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 20, height: 19)
                    Text("Назад")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                }
                
                Text("Сбросить пароль")
                    .font(.system(size: 48, weight: .bold))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .foregroundStyle(.black)
                    .padding(.bottom, -8)
            }
            
            VStack {
                
                if isErrorSendResentPasswordOpt {
                    Text("Невозможно отправить код для сброса пароля. Убедитесь что аккаунт с данной почтой существует.")
                        .foregroundStyle(Color.dmbRed)
                        .font(.manrope(size: 12, weight: .light))
                }
                
                CustomMailTextField(placeholder: "E-mail", text: $email)
                
                RedButton(text: "Отправить код") {
                    Task {
                        await viewModel.sendPasswordResetOtp(email: email)
                    }
                }
            }
            .padding(.vertical)
            

            Spacer()
        }
        .onChange(of: viewModel.viewState) { state in
            switch state {
            case .successSendPasswordResetOtp:
                path.append(MenuCoordinatorEnum.verifyResetPassword)
            case .failureSendPasswordResetOtp:
                isErrorSendResentPasswordOpt = true
            default:
                break
            }
        }
        .overlay(content: {
            if viewModel.viewState == .loading {
                CustomProgressView()
            }
        })
        .padding()
        .background {
            Color.white.ignoresSafeArea()
        }
        
    }
}

#Preview {
    ChangePasswordView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
