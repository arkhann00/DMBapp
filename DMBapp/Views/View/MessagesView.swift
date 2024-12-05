//
//  MessageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var viewModel = MessageViewModel()
    
    @State var isBackgroundDim = false
    
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                
                    VStack {
                        
                        ZStack {
                            ScrollView {
                                VStack {
                                    
                                    if viewModel.viewState == .loading {
                                        ProgressView()
                                    } else {
                                        if let globalChat = viewModel.globalChat, viewModel.isAuthorizedUser() {
                                            NavigationLink {
                                                GlobalChatView(viewModel: viewModel, chat: globalChat)
                                                    .navigationBarBackButtonHidden()
                                            } label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundStyle(.white)
                                                        .frame(width: 380,height: 51)
                                                    Text("ОБЩИЙ ЧАТ")
                                                        .foregroundStyle(.black)
                                                        .font(.custom("benzin-extrabold", size: 15))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.horizontal)
                                                        .padding(.horizontal)
                                                }
                                            }
                                        }
                                        
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
                                            
                                            ScrollView {
                                                ForEach(0 ..< viewModel.chats.count, id:\.self) { i in
                                                    let chat = viewModel.chats[i]
                                                    if chat.chatType == "GLOBAL" {
                                                        
                                                    }
                                                    NavigationLink {
                                                        DirectChatView(viewModel: viewModel, user: chat)
                                                            .navigationBarBackButtonHidden()
                                                    } label: {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .foregroundStyle(.white)
                                                                .frame(width: 380,height: 51)
                                                            HStack {
                                                                CustomImageView(imageString: chat.imageLink, defaultImage: Image(systemName: "person.fill"))
                                                                    .clipShape(Circle())
                                                                    .scaledToFit()
                                                                    .frame(width: 31, height: 31)
                                                                
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
                                                                Task {
                                                                    await viewModel.removeChat(chatId: chat.chatId)
                                                                }
                                                            } label: {
                                                                Text("Удалить чат")
                                                                    .foregroundStyle(.black)
                                                            }
                                                            
                                                        })
                                                    }
                                                    
                                                }
                                                
                                                
                                            }
                                        }
                                    }
                                }
                                .padding(.top,60)
                            }
                            .refreshable {
                                Task {
                                    await self.viewModel.fetchChats()
                                    await self.viewModel.fetchGlobalChat()
                                    await self.viewModel.messages.removeAll()
                                    await self.viewModel.loadingMessages.removeAll()
                                }
                            }
                            VStack {
                                CustomHomeSearchBar(viewModel: HomeViewModel())
                                Spacer()
                            }
                            
                            
                            
                            
                        }
                        Spacer()
                    }
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
                Task {
                    await self.viewModel.fetchChats()
                    await self.viewModel.fetchGlobalChat()
                    await self.viewModel.messages.removeAll()
                    await self.viewModel.loadingMessages.removeAll()
                }
            })
            .overlay {
                if viewModel.viewState == .loading && !viewModel.isAuthorizedUser() {
                    CustomProgressView()
                } else if viewModel.viewState == .failureFetchChats {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text("Нет сети")
                                .foregroundStyle(.black)
                                .font(.custom("benzin-extrabold", size: 20))
                        }
                }
            }
        }
        
    
}

#Preview {
    MessagesView()
}
