//
//  UserCardView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.08.2024.
//

import SwiftUI

struct UserCardView: View {
    
    private let networkNanager = NetworkManager()
    
    @State var userId:String
    @State var user:UserData?
    @ObservedObject var viewModel:HomeViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
            VStack {
                
                HStack {
                    
                    Button { dismiss() } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23, height: 22)
                    }
                    .rotationEffect(.degrees(180))
                    Spacer()
                    
                }
                .padding(.horizontal)
                if let user = user {
                HStack {
                    CustomImageView(imageString: user.avatarLink, defaultImage: Image(systemName: "person.fill"))
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 94, height: 94)
                    
                    VStack(alignment:.leading) {
                        Text("\(user.nickname)")
                            .foregroundStyle(.black)
                            .font(.custom("benzin-regular", size: 12))
                        
                        Spacer()
                    }
                    .padding(.leading, 40)
                    .frame(height: 90)
                    Spacer()
                }
                .padding()
                .onAppear {
                    print(user.id)
                }
                HStack {
                    Button {
                        if user.isFriend {
                            Task {
                                await viewModel.deleteFromFriends(id: user.id)
                            }
                        } else if !(user.isFriend && user.isFriendshipRequestSent && user.isFriendshipRequestRecieved) {
                            Task {
                                await viewModel.sendFriendshipInvite(id: user.id)
                            }
                        } else if user.isFriendshipRequestRecieved {
                            Task {
                                await viewModel.acceptFriendshipInvite(id: user.id)
                            }
                        }
                        
                        
                    } label: {
                        if user.isFriend {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                Text("Удалить из друзей".localize(language: viewModel.getLanguage()))
                                    .font(.custom("benzin-regular", size: 12))
                                    .foregroundStyle(.white)
                            }
                        } else if user.isFriendshipRequestSent {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.white)
                                    .padding(1)
                                Text("Заявка отправлена")
                                    .font(.custom("benzin-regular", size: 12))
                                    .foregroundStyle(.black)
                                
                            }
                        }
                            else if user.isFriendshipRequestRecieved {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.black)
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.white)
                                        .padding(1)
                                    Text("Принять заявку")
                                        .font(.custom("benzin-regular", size: 12))
                                        .foregroundStyle(.black)
                                    
                                }
                                
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.black)
                                    Text("Добавить в друзья".localize(language: viewModel.getLanguage()))
                                        .font(.custom("benzin-regular", size: 12))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                            .frame(maxWidth: .infinity)
                            .frame(height: 26)
                            .padding()
                        
                        
                    }
                .onAppear {
                    Task {
                        await viewModel.fetchFriends()
                    }
                }
                Spacer()
            } else {
                ProgressView()
                Spacer()
            }
            }
            .background {
                Color(.white)
                    .ignoresSafeArea()
            }
            .onAppear {
                Task {
                    await searchUserWuthId()
                }
            }
            .onChange(of: viewModel.viewState) { val in
                switch val {
                case .successDeleteFromFriends, .successAcceptFriendshipInvite, .successSendFriendshipInvite:
                    Task {
                        await searchUserWuthId()
                    }
                    print(user)
                default:
                    break
                }
            }
            
            
            
            Spacer()
        
    }
    
    @MainActor
    private func searchUserWuthId() async {
        await networkNanager.searchUserWithId(id: userId) { response in
            switch response.result {
            case .success(let user):
                self.user = user
                print(user)
            case .failure(_):
                print("ERROR FETCH USER WITH ID")
                response.printJsonError()
            }
        } 
    }
}



