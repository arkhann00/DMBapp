//
//  FirstAndSecondNamesView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.07.2024.
//

import SwiftUI

struct NameView: View {
    
    @State var name = ""
    @State var nick = ""
    
    @FocusState var nameEditing
    @FocusState var nickEditing
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
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
                
                Text("ПРОФИЛЬ")
                    .foregroundStyle(.black)
                    .font(.custom("benzin-extrabold", size: 32))
                    .shadow(radius: 2, x: 0, y: 4)
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                
                TextField("", text: $name)
                    .padding(20)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .foregroundStyle(.black)
                    .background(alignment: .leading) {
                        
                        Text("Имя")
                            .font(.custom("Montserrat", size: 17))
                            .padding(.leading, 3)
                            .foregroundStyle(!nameEditing && name.isEmpty ? .black : .clear)
                            .padding()
                            
                            
                    }
                    .focused($nameEditing)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                            .padding(13)
                    }
                
                TextField("", text: $nick)
                    .padding(20)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 17))
                    .background(alignment: .leading) {
                        Text("Ник-нейм")
                            .font(.custom("Montserrat", size: 17))
                            .padding(.leading, 3)
                            .foregroundStyle(!nickEditing && nick.isEmpty ? .black : .clear)
                            .padding()
                            
                            
                    }
                    .focused($nickEditing)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                            .padding(13)
                    }
                    .padding(.top, -15)
                
                
                CustomAddButton()
                    .padding(.top, 60)
                Text("Добавить фотографию")
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 20))
                    .padding()
                
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
    NameView()
}
