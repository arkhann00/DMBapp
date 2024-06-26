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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                VStack {
                    Text("РЕГЕСТРАЦИЯ")
                        .padding(.top, 79)
                        .font(.custom("benzin-extrabold", size: 32))
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .padding(.horizontal)
                    
                    TextField("Почта", text: $mail)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    TextField("Пароль", text: $password)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(-5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    TextField("Повторите пароль", text: $repeatedPassword)
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
                            
                        } label: {
                            Text("Войти")
                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                .font(.custom("Montserrat", size: 20))
                        }

                    }
                    Spacer()
                    
                }
                .toolbar(.visible, for: .navigationBar)
                .toolbar(content: {
                    NavigationLink {
                        CustomTabBar()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Пропустить")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                    }

                    Text("                                          ")
                    Button {
                        
                    } label: {
                        Text("Далее")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 17,height: 16 )
                    }
                })
            }
        }
    }
}

#Preview {
    RegisterView()
}
