//
//  CustomHomeSearchBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.08.2024.
//

import SwiftUI

struct CustomHomeSearchBar: View {
    @ObservedObject var viewModel:HomeViewModel
    
    @State var searchedText = ""
    @State var isEditing = false
    @State var isPresentUserCard = false
    @FocusState var focusOnKeyBoard:Bool
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
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
                        .onChange(of: searchedText) { newValue in
                            viewModel.searchUserWithName(name: newValue)
                        }
                    
                    
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
            if !viewModel.users.isEmpty && !searchedText.isEmpty {
                ZStack {
                    
                    ScrollView {
                        ForEach (viewModel.users) { user in
                            
                            
                            Button {
                                isPresentUserCard = true
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
                                            if viewModel.isMyFriend(with: user.id) {
                                                viewModel.deleteFromFriends(id: user.id)
                                            } else if viewModel.isAlreadySentFriendshipInvite(with: user.id) {}
                                            else{
                                                viewModel.sendFriendshipInvite(id: user.id)
                                            }
                                        } label: {
                                            if viewModel.isMyFriend(with: user.id) {
                                                Image("trash")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                            } else if viewModel.isAlreadySentFriendshipInvite(with: user.id) {
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .foregroundStyle(.black)
                                                    .frame(width: 18, height: 18)
                                            }
                                            else {
                                                Image("addFriend")
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
                            .navigationDestination(isPresented: $isPresentUserCard, destination: {
                                UserCardView(user: user, viewModel: HomeViewModel())
                                    .navigationBarBackButtonHidden()
                            })
                            .frame(height: 35)
                            
                        }
                        .padding()
                    }
                    .padding(.bottom)
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                            .frame(maxWidth: .infinity)
                    })
                    
                    
                    .scrollContentBackground(.hidden)
                }
                
                
                .onAppear(perform: {
                    viewModel.fetchSentFriendshipInvites()
                })
                
            }
            
        }
    }
}

#Preview {
    CustomHomeSearchBar(viewModel: HomeViewModel())
}
