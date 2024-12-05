//
//   UseTermsView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.09.2024.
//

import SwiftUI

struct UseTermsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .frame(height: 150)
                        
                    VStack {
                        Text("Для продолжения использования приложения,пожалуйста, подтвердите свое согласие с нашими правилами пользования и политикой обработки данных. Нажимая 'Согласен, вы принимаете условия использования и даёте согласие на обработку и передачу ваших персональных данных третьим лицам.")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 9))
                            .padding()
                            .frame(alignment: .center)
                         
                        HStack {
                            Spacer()
                            NavigationLink {
                                RegisterView(viewModel: RegisterViewModel())
                                    .navigationBarBackButtonHidden()
                            } label: {
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 110, height: 30)
                                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                    .overlay {
                                        Text("СОГЛАСЕН")
                                            .font(.custom("benzin-extrabold", size: 10))
                                            .foregroundStyle(.white)
                                    }
                                
                            }
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 110, height: 30)
                                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                Link("ПОДРОБНЕЕ", destination: URL(string: "https://docs.google.com/document/d/12T7h8d8KHKt1FyboCqOCy9R5qc9maAiaNSCG6WLrI-c/edit")!)
                                    .foregroundStyle(.white)
                                    .font(.custom("benzin-extrabold", size: 10))
                            }
                            Spacer()
                        }
                           
                    }
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("MainBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    
            }
            
        }
    }
}

#Preview {
    UseTermsView()
}
