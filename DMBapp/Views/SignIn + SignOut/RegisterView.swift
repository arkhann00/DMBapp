//
//  RegisterView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.06.2024.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    
    @State var mail = ""
    @State var password = ""
    @State var repeatedPassword = ""
    
    @State var isPresentRegisteredNextView = false
    @State var isMismatchPasswords = false
    
    @State var isPasswordHidden = true
    @State var isInvalidMail = false
    
    @FocusState var mailEditing
    @FocusState var passwordEditing
    @FocusState var repeatedPasswordEditing
    
    var body: some View {
        NavigationStack {
            
            VStack {
                HStack {
                    NavigationLink {
                        CustomTabBar(viewState: .offline)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Пропустить".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                    }
                    
                    Spacer()
                    Button {
                        if mail.isValidMail() {
                            isInvalidMail = false
                        } else {
                            isInvalidMail = true
                        }
                        
                        if password == repeatedPassword {
                            isMismatchPasswords = false
                        }
                        else {
                            isMismatchPasswords = true
                        }
                        
                        if mail.isValidMail() && password == repeatedPassword && password.count >= 6 && password.count <= 128 {
                            isPresentRegisteredNextView = true
                        }
                    } label: {
                        Text("Далее".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 17,height: 16 )
                    }
                    .navigationDestination(isPresented: $isPresentRegisteredNextView) {
                        NameView(viewModel: viewModel, mail: mail, password: password)
                            .navigationBarBackButtonHidden()
                    }
                }
                .padding(.horizontal)
                Text("РЕГИСТРАЦИЯ".localize(language: viewModel.getLanguage()))
                    .shadow(radius: 2, x: 0, y: 4)
                    .padding(.top, 79)
                    .font(.custom("benzin-extrabold", size: 32))
                    .foregroundStyle(.black)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                
                TextField("", text: $mail)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Почта".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 17))
                            .padding(.leading, 3)
                            .foregroundStyle(!mailEditing && mail.isEmpty ? .black : .clear)
                        
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                            .padding(-5)
                    }
                    .focused($mailEditing)
                    .frame(maxWidth: .infinity)
                    .padding()
                if isInvalidMail {
                    Text("Неверный формат почты".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .font(.custom("Montserrat", size: 15))
                }
                if isPasswordHidden {
                    SecureField("", text: $password)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .background(alignment: .leading) {
                            Text("Пароль".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!passwordEditing && password.isEmpty ? .black : .clear)
                            
                        }
                        .focused($passwordEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.top)
                    Text("Длина пароля от 6 до 128 символов".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(Color(.gray))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 17))
                        .padding(.horizontal)
                    
                    SecureField("", text: $repeatedPassword)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .background(alignment: .leading) {
                            Text("Повторите пароль".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!repeatedPasswordEditing && repeatedPassword.isEmpty ? .black : .clear)
                            
                        }
                        .focused($repeatedPasswordEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    TextField("", text: $password)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .background(alignment: .leading) {
                            Text("Пароль".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!passwordEditing && password.isEmpty ? .black : .clear)
                            
                        }
                        .focused($passwordEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("Длина пароля от 6 до 128 символов".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(Color(.gray))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 17))
                        .padding(.horizontal)
                    
                    TextField("", text: $repeatedPassword)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .background(alignment: .leading) {
                            Text("Повторите пароль".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!repeatedPasswordEditing && repeatedPassword.isEmpty ? .black : .clear)
                            
                        }
                        .focused($repeatedPasswordEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                
                if isMismatchPasswords {
                    Text("Пароли не совпадают".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .font(.custom("Montserrat", size: 15))
                        .padding(.bottom)
                }
                
                HStack {
                    Button {
                        withAnimation {
                            isPasswordHidden.toggle()
                        }
                    } label: {
                        Image(systemName: isPasswordHidden ? "eye" : "eye.slash")
                        Text(isPasswordHidden ? "Показать пароль".localize(language: viewModel.getLanguage()) : "Скрыть пароль".localize(language: viewModel.getLanguage()))
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal)
                    .font(.custom("Montserrat", size: 15))
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("Есть аккаунт?".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 20))
                    NavigationLink {
                        AuthView(viewModel: viewModel)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Войти".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                            .font(.custom("Montserrat", size: 20))
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                            }
                    }
                    
                }
                Spacer()
                
            }
            .background {
                Color(.white)
                    .ignoresSafeArea()
            }
            
        }
    }
    
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
}
