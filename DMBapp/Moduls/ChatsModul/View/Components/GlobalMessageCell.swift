//
//  GlobalMessageCell.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

struct GlobalMessageCell: View {
    
    @ObservedObject var viewModel:ChatsViewModel
    @State var message: Message
    
    var replyComplition:() -> () = {}
    var editComplition:() -> () = {}
    var replyMessageTap: (String) -> () = { _ in }
    
    @State var offset: CGSize = .zero
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    private let maxSwipeOffset: CGFloat = 100
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            if !message.isSender {
                CustomNetworkImage(viewModel: viewModel, avatarLink: message.senderAvatarLink, defaultImage: Image(systemName: "person.fill"))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.black)
                    .clipShape(Circle())
            } 
            
            VStack(alignment: .leading) {
                
                if !message.attachmentLinks.isEmpty {
                    ForEach(message.attachmentLinks, id:\.self) { link in
                        MessageImage(imageString: link, defaultImage: Image(systemName: "photo"))
                            .frame(width: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                if let repliedMessageText = message.repliedMessageText, let repliedMessageSender = message.repliedMessageSender, let repliedMessageId = message.repliedMessageId {
                    
                    VStack(alignment: .leading) {
                        Text(repliedMessageSender)
                            .frame(alignment: .leading)
                            .foregroundStyle(message.isSender ? .white : .black)
                            .opacity(0.5)
                            .font(.manrope(size: 10))
                        
                        Text(repliedMessageText)
                            .frame(alignment: .leading)
                            .foregroundStyle(message.isSender ? .white : .black)
                            .font(.manrope(size: 10))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: message.text.count > message.senderNickname.count || message.isSender ? CGFloat(message.text.count) * 7.3 : CGFloat(message.senderNickname.count) * 6 , alignment: .leading)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(message.isSender ? Color.white.opacity(0.16) : Color.black.opacity(0.05))
                    }
                    .onTapGesture {
                        replyMessageTap(repliedMessageId)
                    }
                }
                
                if !message.isSender {
                    Text("@\(message.senderNickname)")
                        .frame(alignment: .leading)
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                        .font(.manrope(size: 10))
                        .padding(.bottom, 2)
                }
                
                Text(message.text)
                    .foregroundStyle(message.isSender ? .white : .black)
                    .font(.manrope(size: 14))
            }
            
            .frame(minWidth: 30)
            .padding()
            .overlay(alignment: .bottomTrailing) {
                
                
                
                HStack(spacing: 2) {
                    
                    if message.isEdited {
                        Text("изменено")
                            .foregroundStyle(message.isSender ? .white : Color.dmbBlack)
                            .font(.manrope(size: 10))
                    }
                    
                    Text("\(message.creationTime)")
                        .foregroundStyle(message.isSender ? .white : Color.dmbBlack)
                        .font(.manrope(size: 10))
                    
                    if message.isSender {
                        Image(message.isRead ? Images.twoMarks() : Images.oneMark())
                            .resizable()
                            .frame(width: 11, height: 7)
                    }
                    
                    
                }
                .opacity(0.5)
                .padding(.trailing,6)
                .padding(.bottom, 3)
            }
            .foregroundStyle(message.isSender ? .white : .black)
            .background(
                MessageBubble(isSender: message.isSender)
                    .foregroundStyle(message.isSender ? Color.dmbRed : Color.dmbWhite)
            )
            .contextMenu(menuItems: {
                if viewModel.isAuthorizedUser() {
                    Button {
                        replyComplition()
                    } label: {
                        Text("Ответить")
                    }
                    
                    if message.isSender {
                        Button {
                            Task {
                                await viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
                            }
                        } label: {
                            Text("Удалить")
                        }
                        
//                        Button {
//                            editComplition()
//                        } label: {
//                            Text("Редактировать")
//                        }
//
                    } else {
                        if viewModel.isAdmin() {
                            
                            Button {
                                Task {
                                    await viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
                                }
                            } label: {
                                Text("Удалить")
                            }
                            
                            Button {
                                viewModel.banUser(userId: message.senderId)
                            } label: {
                                Text("Забанить человека")
                            }
                            
                            Button {
                                viewModel.unbanUser(userId: message.senderId)
                            } label: {
                                Text("Разбанить человека")
                            }
                            
                        }
                    }
                    
                }
                
            })
            .offset(offset)
            .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
            
        }
        
    }
}

#Preview {
    GlobalMessageCell(viewModel: ChatsViewModel(), message: Message(id: "", chatId: "", senderId: "", senderNickname: "aaaaaaaaaa", senderAvatarLink: nil, text: "wkfmno", attachmentLinks: [], creationDate: "", creationTime: "12:40", isRead: true, isEdited: false, isSender: false, repliedMessageId: nil, repliedMessageText: "AAAAAAA", repliedMessageSender: "bbbbb"), replyComplition: {
        
    }, editComplition: {
        
    })
    .background(Color.black.frame(height: UIScreen.main.bounds.height))
    .colorScheme(.dark)
}
