//
//  AuthView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.07.2024.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    
    @State var mail = ""
    @State var password = ""
    
    @State var isPresentAuthNextView = false
    @State var isInvalidMail = false
    @State var isPasswordEmpty = false
    
    @State var isPresentNextView = false
    
    @State var isIncorrectPassword = false
    @State var isDataNotFound = false
    @State var isInvalidInputFormat = false
    @State var isFailureAuth = false
    
    
    
    @State var isPasswordHidden = true
    
    @FocusState var mailEditing
    @FocusState var passwordEditing
    
    var body: some View {
        NavigationStack {
            if viewModel.viewState == .loading {
                ProgressView()
            }
            else if viewModel.viewState != .loading && viewModel.viewState != .successReg {
                VStack {
                    HStack {
                        NavigationLink {
                            DateView(viewModel: viewModel)
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
                            
                            if password.isEmpty {
                                isPasswordEmpty = true
                            } else {
                                isInvalidMail = false
                            }
                            
                            if mail.isValidMail() && !password.isEmpty {
                                viewModel.authorizationAccount(mail: mail, password: password)
                            }
                        } label: {
                            Text("Далее".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 12))
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 17,height: 16 )
                        }
                        .navigationDestination(isPresented: $isPresentNextView) {
                            CustomTabBar()
                                .navigationBarBackButtonHidden()
                        }
                        
                        
                    }
                    .padding()
                    .padding(.bottom)
                    Text("ВХОД".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("benzin-extrabold", size: 32))
                        .shadow(radius: 2, x: 0, y: 4)
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    
                    TextField("", text: $mail)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(20)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .foregroundStyle(.black)
                        .background(alignment: .leading) {
                            
                            Text("Почта".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!mailEditing && mail.isEmpty ? .black : .clear)
                            
                                .padding()
                            
                            
                        }
                        .focused($mailEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(13)
                        }
                    if isInvalidMail {
                        Text("Неверный формат почты".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .font(.custom("Montserrat", size: 15))
                            .padding(.bottom)
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
                            .padding(.bottom)
                    } else {
                        TextField("", text: $password)
                            .foregroundStyle(.black)
                            .autocorrectionDisabled()
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
                            .padding(.bottom)
                        
                    }
                    if isPasswordEmpty {
                        Text("Заполните пароль".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .font(.custom("Montserrat", size: 15))
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
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("Нет аккаунта?".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 20))
                        NavigationLink {
                            RegisterView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Зарегестрироваться".localize(language: viewModel.getLanguage()))
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color(.white)
                        .ignoresSafeArea()
                }
                .overlay(content: {
                    
                    if viewModel.viewState == .loading {
                        ProgressView()
                    }
                    
                    if isInvalidInputFormat {
                        InvalidInputFormatErrorView(isPresented: $isInvalidInputFormat)
                    }
                    if isIncorrectPassword {
                        IncorrectPasswordErrorView(isPresented: $isIncorrectPassword)
                    }
                    if isDataNotFound {
                        DataNotFoundErrorView(isPresented: $isDataNotFound)
                    }
//                    if isFailureAuth {
//                        FailureRegErrorView(isPresented: $isFailureAuth)
//                    }
                })
                
            }
            
        }
        .onChange(of: viewModel.viewState) { val in
            withAnimation {
                switch val {
                case .invalidInputFormat:
                    isInvalidInputFormat = true
                case .incorrectPassword:
                    isIncorrectPassword = true
                case .dataNotFound:
                    isDataNotFound = true
                case .successAuth:
                    isPresentNextView = true
                case .none:
                    break
                default:
                    isFailureAuth = true
                    
                }
            }
        }
        
    }
    
}

#Preview {
    AuthView(viewModel: RegisterViewModel())
}
