//
//  FriendsView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.08.2024.
//

import SwiftUI

struct FriendsView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    @State var language:String = "default"
    
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.language = viewModel.getLanguage()
    }
    
    var body: some View {
        NavigationStack {
            
            
            VStack {
                HStack {
                    
                    Button { dismiss() } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23, height: 22)
                    }
                    .padding(.horizontal)
                    .rotationEffect(.degrees(180))
                    Spacer()
                }
                HStack {
                    Text("ДРУЗЬЯ".localize(language: viewModel.getLanguage()))
                        .font(.custom("benzin-extrabold", size: 24))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    if viewModel.isAuthorizedUser() {
                        NavigationLink {
                            FriendshipInvitesView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Заявки в друзья".localize(language: viewModel.getLanguage()))
                                .frame(width: 150,height: 35)
                                .font(.custom("benzin-regular", size: 12))
                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                .overlay(alignment: .topTrailing) {
                                    if !viewModel.friendshipInvites.isEmpty {
                                        Circle()
                                            .frame(width: 11, height: 11)
                                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                            .padding(.bottom)
                                            .overlay(alignment: .center) {
                                                Text("\(viewModel.friendshipInvites.count)")
                                                    .foregroundStyle(.white)
                                                    .font(.custom("benzin-extrabold", size: 6))
                                                    .padding()
                                            }
                                    }
                                }
                            
                        }
                    }
                    
                }
                .padding()
                if !viewModel.isAuthorizedUser() {
                    Spacer()
                    Text("Войдите в аккаунт".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("benzin-regular", size: 20))
                    Spacer()
                } else if viewModel.viewState == .failureFetchFriends {
                    Spacer()
                    Text("Нет сети".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("benzin-regular", size: 20))
                    Spacer()
                } else {
                    ZStack(alignment: .top) {
                        
                        VStack {
                            ScrollView {
                                ForEach(viewModel.friends) { friend in
                                    NavigationLink {
                                        UserCardView(user: friend, viewModel: viewModel)
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        VStack {
                                            HStack {
                                                if let imageStr = friend.avatarImageName {
                                                    CustomImageView(imageUrl: imageStr)
                                                        .frame(width: 25, height: 25)
                                                } else {
                                                    Image(systemName: "person.fill")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                }
                                                Text("\(friend.name)")
                                                    .foregroundStyle(.black)
                                                Spacer()
                                                Button {
                                                    viewModel.deleteFromFriends(id: friend.id)
                                                    viewModel.fetchFriends()
                                                } label: {
                                                    Image("trash")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                }
                                                
                                                
                                            }
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundStyle(.black)
                                        }
                                        .padding(.horizontal)
                                        .listRowSeparator(.hidden)
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .scrollContentBackground(.hidden)
                            
                            Spacer()
                        }
                        .padding(.top, 70)
                        .onAppear(perform: {
                            viewModel.fetchFriendshipInvites()
                            viewModel.fetchFriends()
                        })
                        CustomHomeSearchBar(viewModel: viewModel)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                
            }
            .background(content: {
                Color(.white)
                    .ignoresSafeArea()
            })
        }
    }
}

#Preview {
    FriendsView(viewModel: HomeViewModel())
}
