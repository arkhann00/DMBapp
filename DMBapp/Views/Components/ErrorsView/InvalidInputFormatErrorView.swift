//
//  InvalidInputFormatErrorView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 21.09.2024.
//

import SwiftUI

struct InvalidInputFormatErrorView: View {
    
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
                            Text("НЕВЕРНЫЙ ФОРМАТ ВВОДА")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-extrabold", size: 15))
                                .padding()
                            Text("Предоставленные входные данные содержат запрещенные символы или слишком длинные. Убедитесь, что введенные вами данные соответствуют требуемому формату и не превышают ограничение на количество символов.")
                                .foregroundStyle(.black)
                                .padding()
                                .font(.custom("Montserrat", size: 12))
                            
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
                            .padding(.bottom,3)
                            
                            
                            
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
