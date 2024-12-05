//
//  MessageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI

struct MessagesView: View {
    
    @ObservedObject var viewModel = MessageViewModel()
    
    @State var isBackgroundDim = false
        
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                
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
                    ZStack {
                        
                        VStack {
//                            Button {
//                                //
//                            } label: {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .foregroundStyle(.white)
//                                        .frame(width: 380,height: 51)
//                                        .padding()
//                                        .overlay(alignment: .leading) {
//                                            Text("ОБЩИЙ ЧАТ".localize(language: viewModel.getLanguage()))
//                                                .multilineTextAlignment(.leading)
//                                                .padding()
//                                                .padding(.leading)
//                                                .font(.custom("benzin-extrabold", size: 20))
//                                                .foregroundStyle(.black)
//                                        }
//                                    
//                                }
//                            }
                            if !viewModel.isAuthorizedUser() {
                                NavigationLink {
                                    RegisterView(viewModel: RegisterViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 380, height: 134)
                                        .padding(.horizontal)
                                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                        .overlay {
                                            Text("ЗАРЕГЕСТРИРОВАТЬСЯ".localize(language: viewModel.getLanguage()))
                                                .font(.custom("benzin-extrabold", size: 18))
                                                .foregroundStyle(.white)
                                                .padding(-10)
                                        }
                                    
                                }
                            }
                            else {
                                if let chats = viewModel.chats {
                                    VStack {
                                        NavigationLink {
                                            GlobalChatView(viewModel: viewModel, user:chats.globalChat)
                                                .navigationBarBackButtonHidden()
                                        } label: {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.white)
                                                .frame(width: 380,height: 51)
                                                .padding()
                                                .overlay {
                                                    HStack {
                                                        Text("ОБЩИЙ ЧАТ".localize(language: viewModel.getLanguage()))
                                                            .multilineTextAlignment(.leading)
                                                            .padding()
                                                            .padding(.leading)
                                                            .font(.custom("benzin-extrabold", size: 20))
                                                            .foregroundStyle(.black)
                                                        Spacer()
                                                        if let unreadMessagesAmount = chats.globalChat.unreadMessagesAmount, unreadMessagesAmount > 0 {
                                                            Circle()
                                                                .fill(Color(red: 180/255, green: 0, blue: 0))
                                                                .frame(width: 24, height: 24)
                                                                .overlay {
                                                                    Text("\(unreadMessagesAmount)")
                                                                        .foregroundStyle(.white)
                                                                        .font(.custom("Montserrat", size: 16))
                                                                }
                                                                .padding(.horizontal)
                                                                .padding(.horizontal)
                                                        }
                                                    }
                                                }
                                        }
                                        
                                        ScrollView {
                                            ForEach(0 ..< chats.chats.count, id:\.self) { i in
                                                let chat = chats.chats[i]
                                                NavigationLink {
                                                    FriendChatView(viewModel: viewModel, user: chat)
                                                        .navigationBarBackButtonHidden()
                                                } label: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .foregroundStyle(.white)
                                                            .frame(width: 380,height: 51)
                                                        HStack {
                                                            if let imageStr = chat.imageLink {
                                                                CustomImageView(imageUrl: imageStr)
                                                                    .frame(width: 31, height: 31)
                                                            } else {
                                                                Image(systemName: "person.fill")
                                                                    .resizable()
                                                                    .frame(width: 31, height: 31)
                                                                    .foregroundStyle(.black)
                                                            }
                                                            VStack(alignment:.leading) {
                                                                Text("\(chat.name)")
                                                                    .foregroundStyle(.black)
                                                                    .font(.custom("Montserrat", size: 12))
                                                                if let lastMessageText = chat.lastMessageText, let lastMessageSenderName = chat.lastMessageSenderName {
                                                                    Text("\(lastMessageSenderName): \(lastMessageText)")
                                                                        .font(.custom("Montserrat", size: 9))
                                                                        .foregroundStyle(.black)
                                                                        .opacity(0.5)
                                                                }
                                                            }
                                                            Spacer()
                                                            if let lastMessageTime = chat.lastMessageCreationTime {
                                                                VStack {
                                                                    Text("\(lastMessageTime)")
                                                                        .font(.custom("Montserrat", size: 6))
                                                                        .foregroundStyle(.black)
                                                                    Circle()
                                                                        .fill(chat.unreadMessagesAmount == 0 || chat.unreadMessagesAmount == nil ? .white : Color(red: 180/255, green: 0, blue: 0))
                                                                        .frame(width: 24, height: 24)
                                                                        .overlay {
                                                                            if let unreadMessagesAmount = chat.unreadMessagesAmount, unreadMessagesAmount > 0 {
                                                                                Text("\(unreadMessagesAmount)")
                                                                                    .foregroundStyle(.white)
                                                                                    .font(.custom("Montserrat", size: 16))
                                                                            }
                                                                        }
                                                                }
                                                            }
                                                        }
                                                        .padding(.horizontal)
                                                        .padding(.horizontal)
                                                    }
                                                    .foregroundStyle(.black)
                                                    .menuStyle(BorderlessButtonMenuStyle())
                                                    .contextMenu(menuItems: {
                                                        Button {
                                                            viewModel.removeChat(chatId: chat.chatId)
                                                        } label: {
                                                            Text("Удалить чат")
                                                                .foregroundStyle(.black)
                                                        }
                                                        
                                                    })
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding(.top,60)
                        VStack {
                            CustomHomeSearchBar(viewModel: HomeViewModel())
                            Spacer()
                        }
                        
                    }
                    Spacer()
                }
                
            }
            .background(content: {
                viewModel.getBackgroundImage()
                    .resizable()
                    .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                    .frame(maxWidth: .infinity)
                    .scaledToFill()
                    .ignoresSafeArea()
            })
            .onAppear(perform: {
                isBackgroundDim = viewModel.getIsDimBackground()
                
            })
        }
        
    }
}

#Preview {
    MessagesView()
}
