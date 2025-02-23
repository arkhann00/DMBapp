//
//  FriendshipInvitesView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 21.08.2024.
//

import SwiftUI

struct FriendshipInvitesView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
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
                Text("ЗАЯВКИ В ДРУЗЬЯ".localize(language: viewModel.getLanguage()))
                    .font(.custom("benzin-extrabold", size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding()
            if viewModel.requestResult == .failure {
                Spacer()
                Text("Нет сети".localize(language: viewModel.getLanguage()))
                    .foregroundStyle(.black)
                    .font(.custom("benzin-regular", size: 20))
                Spacer()
            } else {
                if viewModel.friendshipInvites.isEmpty {
                    Spacer()
                    Text("Заявок нет".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("benzin-regular", size: 20))
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(viewModel.friendshipInvites) { user in
                            
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 105)
                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                .overlay {
                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("Пользователь".localize(language: viewModel.getLanguage()))
                                                NavigationLink {
                                                    UserCardView(user: UserData(id: user.senderId, name: user.senderName, nickname: user.senderNickname, avatarImageName: user.senderAvatarImageName), viewModel: viewModel)
                                                        .navigationBarBackButtonHidden()
                                                } label: {
                                                    Text("\(user.senderName)")
                                                        .overlay(alignment: .bottom) {
                                                            Rectangle()
                                                                .foregroundStyle(.white)
                                                                .frame(height: 1)
                                                        }
                                                }
                                                Text("хочет".localize(language: viewModel.getLanguage()))
                                            }
                                            Text("добавить  Вас  в  друзья".localize(language: viewModel.getLanguage()))
                                        }
                                        .padding()
                                        .foregroundStyle(.white)
                                        .font(.custom("benzin-regular", size: 9))
                                        HStack {
                                            
                                            Button {
                                                viewModel.acceptFriendshipInvite(id: user.senderId)
                                            } label: {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundStyle(.white)
                                                    .frame(width: 77, height: 26)
                                                    .overlay {
                                                        Text("Принять".localize(language: viewModel.getLanguage()))
                                                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                                            .font(.custom("benzin-regular", size: 9))
                                                    }
                                            }
                                            .padding(.horizontal)
                                            
                                            Button {
                                                
                                            } label: {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundStyle(.white)
                                                    .frame(width: 77, height: 26)
                                                    .overlay {
                                                        Text("Отклонить".localize(language: viewModel.getLanguage()))
                                                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                                            .font(.custom("benzin-regular", size: 9))
                                                    }
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                    }
                                }
                            
                        }
                    }
                    .padding()
                }
            }
        }
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    FriendshipInvitesView(viewModel: HomeViewModel())
}
