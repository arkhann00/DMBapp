//
//  CustomSearchBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI

struct CustomMessageSearchBar: View {
    
    @ObservedObject var viewModel:MessageViewModel
    
    @State var searchedText = ""
    @State var isEditing = false
    @FocusState var focusOnKeyBoard:Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .frame(width: 380, height: 33)
                    .padding()
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    TextField("", text: $searchedText)
                        .font(.custom("Montserrat", size: 20))
                        .padding(.horizontal,3)
                        .focused($focusOnKeyBoard)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            isEditing = true
                            
                        }
                        .background(alignment: .leading) {
                            Text("Найти пользователя".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 20))
                                .padding(.leading, 3)
                                .foregroundStyle(isEditing == false ? .black : .clear)
                                .transaction { transaction in
                                    transaction.animation = .default
                                }
                        }
                        .onChange(of: searchedText, perform: { value in
                            viewModel.searchUserWithName(name: value)
                        })
                        
                    
                    
                    if isEditing {
                        withAnimation(.default) {
                            Button {
                                focusOnKeyBoard = false
                                isEditing = false
                                searchedText = ""
                                
                            } label: {
                                Text("Отмена")
                                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                    .font(.custom("Monsterrat", size: 20))
                            }
                            .padding(.trailing)
                            .transition(.move(edge: .trailing))
                        }
                        
                        
                    }
                }
                .padding()
            }
            if !viewModel.users.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                    ScrollView {
                        ForEach (viewModel.users) { user in
                            
                            
                            NavigationLink {
                                UserCardView(user: user, viewModel: HomeViewModel())
                                    .navigationBarBackButtonHidden()
                            } label: {
                                VStack {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.black)
                                        Text("\(user.name)")
                                            .foregroundStyle(.black)
                                            .font(.custom("Montserrat", size: 17))
                                            .padding(.trailing)
                                        
                                        Spacer()
                                        Button {
                                            
                                        } label: {
                                            if false {
                                                Image("addFriend")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                            } else {
                                                Image("trash")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    Rectangle()
                                        .foregroundStyle(.black)
                                        .frame(height: 1)
                                }
                                
                                
                                
                            }
                            .frame(height: 35)
                            
                        }
                        .padding()
                    }
                    .padding()
                    
                    .scrollContentBackground(.hidden)
                }
                .padding()
                
            }
        }
    }
}

#Preview {
    CustomMessageSearchBar(viewModel: MessageViewModel())
}
