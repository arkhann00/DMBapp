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
    @State var nickname = ""
    
    @State var isPresentNextView = false
    @State var isMismatchPasswords = false
    
    @State var isPasswordHidden = true
    @State var isInvalidMail = false
    @State var isInvalidNickname = false
    
    @State var isInvalidNicknameCharacters = false
    
    @State var isNickNameTaken = false
    @State var isInvalidInputFormat = false
    @State var isFailureReg = false
    @State var isAccountAlreadyExists = false
    @State var isInvalidPassword = false
    
    
    
    @FocusState var mailEditing
    @FocusState var passwordEditing
    @FocusState var repeatedPasswordEditing
    @FocusState var nicknameEditing
    
    var body: some View {
        NavigationStack {
            
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
                        
                        if password == repeatedPassword {
                            isMismatchPasswords = false
                        }
                        else {
                            isMismatchPasswords = true
                        }
                        
                        if nickname.count < 4 {
                            isInvalidNickname = true
                        }
                        else {
                            isInvalidNickname = false
                        }
                        
                        if nickname.isEnglishLettersOrDigits() {
                            isInvalidNicknameCharacters = false
                            print("nickname is invalid")
                        } else {
                            isInvalidNicknameCharacters = true
                        }
                        
                        if password.count < 6 || password.count > 128 {
                            isInvalidPassword = true
                        } else {
                            isInvalidPassword = false
                        }
                        
                        if mail.isValidMail() && password == repeatedPassword && password.count >= 6 && password.count <= 128 && nickname.count >= 4 &&
                           nickname.isEnglishLettersOrDigits() {
                            Task {
                                await viewModel.registerAccount(mail: mail, password: password, nickname: nickname)
                            }
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
                        EmailConfirmationView(viewModel: viewModel, mail: mail)
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
                
                TextField("", text: $nickname)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Ник-нейм".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 17))
                            .padding(.leading, 3)
                            .foregroundStyle(!nicknameEditing && nickname.isEmpty ? .black : .clear)
                        
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                            .padding(-5)
                            .frame(height: 20)
                    }
                    .focused($nicknameEditing)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top)
                if isInvalidNickname {
                    Text("Ник-нейм содержит меньше 4 символов")
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 16))
                        .padding(.horizontal)
                        .lineLimit(nil)
                } else if isInvalidNicknameCharacters {
                    Text("Ник-нейм должен состоять из английских букв или цифр")
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 16))
                        .padding(.horizontal)
                        .lineLimit(nil)
                } else {
                    Text("Ник-нейм должен состоять из английских букв или цифр и содержать от 4 символов")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 16))
                        .padding(.horizontal)
                        .lineLimit(nil)
                }
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
                            .frame(height: 20)
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
                                .frame(height: 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.top)
                    Text("Длина пароля от 6 до 128 символов".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(isInvalidPassword ? .red : .gray)
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
                                .frame(height: 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
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
                        .autocorrectionDisabled()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                                .frame(height: 20)
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
                                .frame(height: 20)
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
            .overlay {
                
                if viewModel.viewState == .loading {
                    ProgressView()
                }
                
                
                
                if isNickNameTaken {
                    withAnimation {
                        NickNameIsTakenErrorView(isPresented: $isNickNameTaken)
                    }
                    
                }
//                if isInvalidNickname {
//                    withAnimation {
//                        NicknameCharactersCountErrorView(isPresented: $isInvalidNickname)
//                    }
//                }
                if isInvalidInputFormat {
                    withAnimation {
                        InvalidInputFormatErrorView(isPresented: $isInvalidInputFormat)
                    }
                }
                
                if isAccountAlreadyExists {
                    withAnimation {
                        AccountAlreadyExistsErrorView(isPresented: $isAccountAlreadyExists)
                    }
                }
                if isFailureReg {
                    withAnimation {
                        FailureRegErrorView(isPresented: $isFailureReg)
                    }
                }
            }
            
        }
        .onChange(of: viewModel.viewState) { val in
            withAnimation {
                switch val {
                case .nicknameIsTaken:
                    isNickNameTaken = true
                case .invalidInputFormat:
                    isInvalidInputFormat = true
                case .accountAlreadyExists:
                    print(123)
                    isAccountAlreadyExists = true
                case .failureReg:
                    isFailureReg = true
                case .loading:
                    break
                case .none:
                    break
                case .successReg:
                    isPresentNextView = true
                default:
                    isFailureReg = true
                }
            }
        }
    }
    
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
}
