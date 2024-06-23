//
//  MessageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI

struct MessageView: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        NavigationLink {
                            SettingsView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image("Settings")
                                .resizable()
                                .frame(width: 33, height: 26)
                        }
                    
                        Spacer()

                    }
                    .padding()
                    CustomSearchBar()
                    
                    Button {
                        //
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.white)
                                .frame(width: 380,height: 51)
                                .padding()
                            HStack {
                                Text("ОБЩИЙ ЧАТ")
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                    .padding()
                                    .font(.custom("benzin-extrabold", size: 20))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                            }
                        }
                    }

                    Button {
                        //
                    } label: {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 380, height: 134)
                            .padding(.horizontal)
                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                            .overlay {
                                Text("ЗАРЕГЕСТРИРОВАТЬСЯ")
                                    .font(.custom("benzin-extrabold", size: 22))
                                    .foregroundStyle(.white)
                            }
                        
                    }

                    
                    Spacer()

                }
                
            }
        }
        
    }
}

#Preview {
    MessageView()
}
