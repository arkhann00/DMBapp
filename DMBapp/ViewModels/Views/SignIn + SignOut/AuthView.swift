//
//  AuthView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.07.2024.
//

import SwiftUI

struct AuthView: View {
    
    @State var mail = ""
    @State var password = ""
    
    @FocusState var mailEditing
    @FocusState var passwordEditing
    
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
                .padding()
                .padding(.bottom)
                Text("ВХОД")
                    .foregroundStyle(.black)
                    .font(.custom("benzin-extrabold", size: 32))
                    .shadow(radius: 2, x: 0, y: 4)
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                
                TextField("", text: $mail)
                    .padding(20)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .foregroundStyle(.black)
                    .background(alignment: .leading) {
                        
                        Text("Почта")
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
                
                TextField("", text: $password)
                    .padding(20)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Пароль")
                            .font(.custom("Montserrat", size: 17))
                            .foregroundStyle(.black)
                            .padding(.leading, 3)
                            .foregroundStyle(!passwordEditing && password.isEmpty ? .black : .clear)
                            .padding()
                            
                            
                    }
                    .focused($passwordEditing)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                            .padding(13)
                    }
                    .padding(.top, -15)
                
                Text("Войти через")
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 20))
                    .padding(.top, 50)
                HStack {
                    Button {
                        
                    } label: {
                        Image("gmailLogo")
                            .resizable()
                            .frame(width: 74, height: 70)
                        
                        
                    }
                    Button {
                        
                    } label: {
                        Image("vkLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }


                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(.white)
                    .ignoresSafeArea()
            }
            
        }
        
    }
    
}

#Preview {
    AuthView()
}
