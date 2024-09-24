//
//  FriendChatView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.08.2024.
//

import SwiftUI
import PhotosUI

struct FriendChatView: View {
    @ObservedObject var viewModel:MessageViewModel
    private let userDefaults = UserDefaultsManager.shared
    
    @State var user:Chat
    @State var isBackgroundDim = false
    
    @State var photoPickerItem:PhotosPickerItem?
    
    @State var images:[UIImage] = []
    
    @State var isEditingMessage = false
    @State var isPresentVideosAndImages = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(viewModel.friendMessages?.messages ?? []) { message in
                            ZStack {
                                
                                if message.isSender {
                                    VStack(alignment:.leading) {
                                        
                                        if message.senderId == -1 {
                                            Text("\(message.text)")
                                                .font(.custom("Montserrat", size: 16))
                                                .padding()
                                                .foregroundStyle(.black)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundStyle(Color(red:211/255, green: 211/255, blue: 211/255))
                                                        .overlay(alignment: .bottomTrailing) {
                                                            
                                                            
                                                            
                                                            Image("clock")
                                                                .resizable()
                                                                .frame(width:12, height:12)
                                                            
                                                                .padding(.trailing,4)
                                                            
                                                        }
                                                    
                                                        .padding(-5)
                                                }
                                            
                                        } else {
                                            VStack {
                                                if !message.attachmentLinks.isEmpty {
                                                    ForEach(message.attachmentLinks, id: \.self) { link in
                                                        MessageImageView(imageUrl: link)
                                                            .scaledToFit()
                                                            .frame(maxWidth: 250)
                                                    }
                                                }
                                                
                                                Text("\(message.text)")
                                                    .font(.custom("Montserrat", size: 16))
                                                    .padding()
                                                    .foregroundStyle(.black)
                                                    .frame(alignment:.leading)
                                            }
                                            .background {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundStyle(Color(red:211/255, green: 211/255, blue: 211/255))
                                                    .overlay(alignment: .bottomTrailing) {
                                                        HStack {
                                                            Text("\(message.creationTime)")
                                                                .foregroundStyle(.black)
                                                                .opacity(0.5)
                                                                .font(.custom("Montserrat", size: 9))
                                                                .padding(.trailing, -5)
                                                            Image("checkMark")
                                                                .resizable()
                                                                .frame(width:12, height:12)
                                                                .overlay {
                                                                    if message.isRead {
                                                                        Image("checkMark")
                                                                            .resizable()
                                                                            .frame(width:12, height:12)
                                                                            .padding(.leading,5)
                                                                    }
                                                                }
                                                                .padding(.trailing,4)
                                                        }
                                                    }
                                                
                                                    .padding(-5)
                                            }
                                            .overlay(content: {
                                                Rectangle()
                                                    .foregroundStyle(.clear)
                                                    .menuStyle(BorderlessButtonMenuStyle())
                                                    .contextMenu(ContextMenu(menuItems: {
                                                        Button {
                                                            withAnimation(.default) {
                                                                withAnimation {
                                                                    viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
                                                                }
                                                                
                                                            }
                                                            
                                                        } label: {
                                                            Text("Удалить".localize(language: viewModel.getLanguage()))
                                                        }
                                                    }))
                                            })
                                        }
                                    }
                                    
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.horizontal)
                                    
                                    
                                } else {
                                    VStack(alignment:.trailing) {
                                        Text("\(message.text)")
                                            .font(.custom("Montserrat", size: 16))
                                            .padding()
                                            .foregroundStyle(.black)
                                            .background(alignment: .topLeading) {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                                                    .overlay(alignment: .bottomTrailing) {
                                                        Text("\(message.creationTime)")
                                                            .foregroundStyle(.black)
                                                            .opacity(0.5)
                                                            .font(.custom("Montserrat", size: 9))
                                                            .padding(.trailing, 4)
                                                    }
                                                
                                                    .padding(-5)
                                            }
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    
                                }
                            }
                            .padding(.vertical,4)
                            .rotationEffect(.degrees(180))
                            
                        }
                        
                    }
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                    .rotationEffect(.degrees(180))
                    .padding(.top, 70)
                    .overlay(alignment: .bottomLeading) {
                        ScrollView(.horizontal) {
                            ForEach(0 ..< images.count, id: \.self) { num in
                                
                                Image(uiImage: images[num])
                                    .resizable()
                                    .scaledToFit()
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            images.remove(at: num)
                                        } label: {
                                            Circle()
                                                .foregroundStyle(Color(red:242/255,green: 242/255, blue: 242/255))
                                                .frame(width: 20)
                                                .overlay {
                                                    Image(systemName: "minus")
                                                        .rotationEffect(.degrees(45))
                                                        .foregroundStyle(.gray)
                                                    Image(systemName: "minus")
                                                        .rotationEffect(.degrees(-45))
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                            }
                            
                        }
                        .frame(height: 100)
                        
                    }
                    
                    MessageInput(viewModel: viewModel, friend: user, isPresentVideosAndImages: $isPresentVideosAndImages, images: $images)
                        .onAppear(perform: {
                            viewModel.fetchMessanges(chatId: user.chatId)
                        })
                    
                }
                
            }
            .overlay(alignment: .top, content: {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(height: 120)
                    .ignoresSafeArea()
                    .overlay(alignment: .topLeading) {
                        HStack {
                            Button { dismiss() } label: {
                                Image("BlackArrow")
                                    .resizable()
                                    .frame(width: 23, height: 22)
                            }
                            .rotationEffect(.degrees(180))
                            .padding(.trailing)
                            
                            Spacer()
                            if let user = viewModel.friendMessages?.companion {
                                NavigationLink {
                                    UserCardView(user: user, viewModel: HomeViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    
                                    Text("\(user.name)")
                                        .foregroundStyle(.black)
                                        .font(.custom("Montserrat", size: 18))
                                        .padding(.horizontal)
                                    
                                    
                                }
                                Spacer()
                                NavigationLink {
                                    UserCardView(user: user, viewModel: HomeViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    if let imageUrl = self.user.imageLink {
                                        CustomImageView(imageUrl: imageUrl)
                                            .frame(width: 39, height: 39)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 39, height: 39)
                                            .clipShape(Circle())
                                            .foregroundStyle(.black)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
            })
            .onTapGesture {
                isPresentVideosAndImages = false
            }
            .background(content: {
                
                viewModel.getBackgroundImage()
                    .resizable()
                    .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                    .frame(maxWidth: .infinity)
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresentVideosAndImages = false
                    }
                
            })
            .onChange(of: viewModel.friendMessages?.messages, perform: { _ in
                viewModel.readAllMessages(chatId:user.chatId)
            })
            .onAppear(perform: {
                viewModel.readAllMessages(chatId: user.chatId)
                isBackgroundDim = viewModel.getIsDimBackground()
            })
            
        }
    }
    
    private func fetchImageData(imageLink:String) {
        
    }
}

#Preview {
    FriendChatView(viewModel: MessageViewModel(), user: Chat(chatId: 0, name: "aaaa", imageLink: "", lastMessageText: "", lastMessageCreationTime: "", lastMessageSenderName: "", unreadMessagesAmount: 0, isGroupChat: false, isOnline: false))
}
