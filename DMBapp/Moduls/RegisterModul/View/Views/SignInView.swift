//
//  SignInView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.12.2024.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    @Binding var path:NavigationPath
    
    @State var mail = ""
    @State var password = ""
    
    @State var isMail = true
    @State var isPassword = true
    
    @State var errorText:String?
    
    @State var isSuccessAuth = false
    
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
            
            Text("Войти в аккаунт")
                .foregroundStyle(.black)
                .font(.system(size: 48, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width/2)
            Spacer()
            
            if let text = errorText {
                Text("\(text)")
                    .foregroundStyle(Color.dmbRed)
                    .font(.manrope(size: 12, weight: .light))
            }
            
            CustomMailTextField(placeholder: "E-mail", text: $mail, isError: isMail)
            CustomPasswordTextField(placeholder: "Пароль", text: $password, isError: isPassword)
            
            Button {
                Task {
                    await viewModel.authorizationAccount(mail: mail, password: password)
                }
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbRed)
                    .frame(height: 61)
                    .overlay {
                        Text("Войти")
                            .foregroundStyle(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            Button {
                path.append(MenuCoordinatorEnum.forgetPassword)
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbWhite)
                    .frame(height: 61)
                    .overlay {
                        Text("Забыли пароль?")
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            
            Spacer()
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(content: {
            if viewModel.viewState == .loading {
                CustomProgressView()
            }
        })
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
        }
        .onChange(of: viewModel.viewState) { state in
            
            switch state {
            case .successAuth:
                path.removeLast(path.count)
            case .missingRequestField:
                errorText = "Заполните все поля"
            case .incorrectPassword:
                errorText = "Неверный пароль"
            case .accountNotVerified:
                errorText = "Этот аккаунт не подтвержденю. Попробуйте зарегестрироваться снова"
            case .dataNotFound:
                errorText = "Неверно введены данные. Проверьте почту или пароль"
            case .databaseError:
                errorText = "Ошибка в базе данных"
            case .failureAuth:
                errorText = "Ошибка входа в аккаунт"
            case .emptyField:
                errorText = "Необходимо заполнить все поля"
            case .invalidInputFormat:
                errorText = "Неверный формат введенных данных"
            default:
                break
            }
            
        }
        
        
    }
}

#Preview {
    SignInView(path: .constant(NavigationPath()))
}
