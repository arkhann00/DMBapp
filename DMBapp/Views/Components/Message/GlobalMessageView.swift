//
//  GlobalMessage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.11.2024.
//

import SwiftUI

struct GroupMessageView: View {
    
    @ObservedObject var viewModel:MessageViewModel
    let message:Message
    
    var body: some View {
        HStack(alignment: .bottom) {
            if message.isSender {
                
                Text(message.text)
                    .foregroundStyle(.black)
                    .font(.custom("Montserrat", size: 16))
                    .padding(12)
                    .background(Color(red:211/255, green: 211/255, blue: 211/255))
                    .clipShape(MessageBubble(isSender: message.isSender))
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(message.creationTime)")
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .font(.custom("Montserrat", size: 9))
                            .padding(.trailing,12)
                            .padding(.bottom, 3)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .trailing)
                    .contextMenu(menuItems: {
                        if message.isSender {
                            Button {
                                Task {
                                    await viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
                                }
                            } label: {
                                Text("Удалить".localize(language: viewModel.getLanguage()))
                            }
                        }
                    })
                    .menuStyle(BorderlessButtonMenuStyle())
                
            } else {
                HStack(alignment: .bottom) {
                    NavigationLink {
                        UserCardView(userId: message.senderId, viewModel: HomeViewModel())
                            .navigationBarBackButtonHidden()
                    } label: {
                        CustomImageView(imageString: message.senderAvatarLink, defaultImage: Image(systemName: "person.fill"))
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            UserCardView(userId: message.senderId, viewModel: HomeViewModel())
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text(message.senderNickname)
                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                .font(.custom("Montserrat", size: 12))
                        }
                        Text(message.text)
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 16))
                    }
                    
                    .padding(12)
                    .background(Color(red:242/255, green: 242/255, blue: 242/255))
                    .clipShape(MessageBubble(isSender: message.isSender))
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(message.creationTime)")
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .font(.custom("Montserrat", size: 9))
                            .padding(.trailing,12)
                            .padding(.bottom, 3)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
        .padding(.horizontal, 2)
    }
    
}
