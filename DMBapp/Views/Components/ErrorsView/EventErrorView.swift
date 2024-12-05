//
//  EventErrorView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 04.10.2024.
//

import SwiftUI

struct EventErrorView: View {
    
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
                            Text("ОШИБКА СОХРАНЕНИЯ СОБЫТИЯ")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-extrabold", size: 15))
                                .padding()
                            Text("Попробуйте ещё раз или попробуйте попытку позже")
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
