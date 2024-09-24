//
//  AccountAlreadyExistsErrorView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 21.09.2024.
//

import SwiftUI

struct AccountAlreadyExistsErrorView: View {
    @Binding var isPresented:Bool
    var body: some View {
        NavigationStack {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: 250)
                    .padding(.horizontal)
                    .overlay {
                        VStack {
                            Text("АККАУНТ УЖЕ СУЩЕСТВУЕТ")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-extrabold", size: 20))
                                .padding()
                            Text("Указанный логин уже связан с существующей учетной записью. Пожалуйста, выберите другой логин или используйте существующую учетную запись для входа.")
                                .foregroundStyle(.black)
                                .padding()
                                .font(.custom("Montserrat", size: 15))
                            
                            Spacer()
                            
                            
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation {
                                        isPresented.toggle()
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(.black)
                                        .frame(width: 120, height: 50)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .padding(2)
                                                .foregroundStyle(.white)
                                                .overlay {
                                                    Text("OK")
                                                        .foregroundStyle(.black)
                                                        .font(.custom("benzin-extrabold", size: 12))
                                                }
                                        }
                                    
                                    
                                }
                                
                                Spacer()
                                NavigationLink {
                                    AuthView(viewModel: RegisterViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                        .frame(width: 120, height: 50)
                                        .overlay {
                                            Text("ВОЙТИ")
                                                .foregroundStyle(.white)
                                                .font(.custom("benzin-extrabold", size: 12))
                                        }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 3)
                        }
                    }
                    
            }
            .frame(maxHeight: .infinity)
            .background {
                Color(.black)
                    .ignoresSafeArea()
                    .opacity(0.5)
            }
        }
    }
}
