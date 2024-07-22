//
//  RegisterView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.06.2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State var mail = ""
    @State var password = ""
    @State var repeatedPassword = ""
    
    @FocusState var mailEditing
    @FocusState var passwordEditing
    @FocusState var repeatedPasswordEditing
    
    var body: some View {
        NavigationStack {
            
            VStack {
                HStack {
                    NavigationLink {
                        CustomTabBar()
                            .environmentObject(CalendarViewModel())
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Пропустить")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Далее")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 17,height: 16 )
                    }
                }
                .padding(.horizontal)
                Text("РЕГЕСТРАЦИЯ")
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
                    
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Почта")
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
                   
                
                TextField("", text: $password)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Пароль")
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
                    .padding()
                
                TextField("", text: $repeatedPassword)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Повторите пароль")
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
                
                Spacer()
                
                HStack {
                    Text("Есть аккаунт?")
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 20))
                    NavigationLink {
                        AuthView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Войти")
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
    RegisterView()
}
