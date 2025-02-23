//
//  SignUpView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.12.2024.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var nickName = ""
    @State var mail = ""
    @State var password = ""
    
    @State var errorText:String?
    
    @State var isNickNameValid = true
    @State var isMail = true
    @State var isPassword = true
    
    @State var isSuccessReg = false
    
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
            
            if let text = errorText {
                Text("\(text)")
                    .foregroundStyle(Color.dmbRed)
                    .font(.manrope(size: 12, weight: .light))
            }
            
            CustomTextFiled(placeholder: "Ник", text: $nickName, isError: isNickNameValid)
            CustomMailTextField(placeholder: "E-mail", text: $mail, isError: isMail)
            CustomPasswordTextField(placeholder: "Пароль", text: $password, isError: isPassword)
            Button {
                Task {
                    await viewModel.registerAccount(mail: mail, password: password, nickname: nickName)
                }
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbRed)
                    .frame(height: 61)
                    .overlay {
                        Text("Зарегистрироваться")
                            .foregroundStyle(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            Button {
                path.append(MenuCoordinatorEnum.signIn)
            } label: {
                Capsule()
                    .foregroundStyle(Color.dmbWhite)
                    .frame(height: 61)
                    .overlay {
                        Text("Уже есть аккаунт")
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                    }
            }
            
            
            Spacer()
            Spacer()
            
            VStack(alignment: .leading) {
                HStack(spacing: 3) {
                    Text("Продолжая, вы соглашаетесь с")
                        .foregroundStyle(Color.dmbBlack.opacity(0.2))
                        .font(.manrope(size: 12))
                    Link(destination: URL(string: "https://duty-timer.sunfesty.ru/privacy-policy")!) {
                        Text("правилами")
                            .foregroundStyle(.black)
                            .font(.manrope(size: 12))
                    }
                }
                HStack(spacing: 3) {
                    
                    Link(destination: URL(string: "https://duty-timer.sunfesty.ru/privacy-policy")!) {
                        Text("пользования")
                            .foregroundStyle(.black)
                            .font(.manrope(size: 12))
                    }
                    
                    Text("и")
                        .foregroundStyle(Color.dmbBlack.opacity(0.2))
                        .font(.manrope(size: 12))
                    
                    Link(destination: URL(string: "https://duty-timer.sunfesty.ru/privacy-policy")!) {
                        Text("политикой приватности")
                            .foregroundStyle(.black)
                            .font(.manrope(size: 12))
                    }
                }
                
            }
            .padding(.bottom, 4)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .blur(radius: viewModel.viewState == .loading ? 2 : 0)
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
            case .successReg:
                path.append(MenuCoordinatorEnum.mailComfirmation)
            case .missingRequestField:
                errorText = "Необходимо заполнить все поля"
            case .databaseError:
                errorText = "Ошибка в базе данных"
            case .nicknameIsTaken:
                errorText = "Пользователь с таким ником уже существует"
            case .failureReg:
                errorText = "Ошибка регистрации"
            case .accountAlreadyExists:
                errorText = "Аккаунт с такой почтой уже существует"
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
    SignUpView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
