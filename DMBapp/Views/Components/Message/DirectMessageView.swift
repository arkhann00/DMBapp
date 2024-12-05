//
//  DirectMessage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.11.2024.
//

import SwiftUI

struct DirectMessageView: View {
    
    @ObservedObject var viewModel:MessageViewModel
    let message:Message
    
    var body: some View {
        //        VStack(alignment:.leading) {
        //            if !message.attachmentLinks.isEmpty {
        //                ForEach(0 ..< message.attachmentLinks.count, id:\.self) { i in
        //                    let link = message.attachmentLinks[i]
        //
        //                    CustomImageView(imageString: link, defaultImage: Image(systemName: "photo"))
        //                        .frame(width: 250)
        //                        .clipShape(RoundedRectangle(cornerRadius: 10))
        //
        //                }
        //            }
        //            Text("\(message.text)")
        //                .font(.custom("Montserrat", size: 16))
        //                .padding()
        //                .foregroundStyle(.black)
        //                .frame(alignment:.leading)
        //        }
        //        .menuStyle(BorderlessButtonMenuStyle())
        //        .background {
        //            Rectangle()
        //                .clipShape(MessageBubble(isSender: message.isSender))
        //                .foregroundStyle(message.isSender ? Color(red:211/255, green: 211/255, blue: 211/255) : Color(red:242/255, green: 242/255, blue: 242/255))
        //                .overlay(alignment: .bottomTrailing) {
        //                    HStack {
        //                        Text("\(message.creationTime)")
        //                            .foregroundStyle(.black)
        //                            .opacity(0.5)
        //                            .font(.custom("Montserrat", size: 9))
        //                            .padding(.trailing, 3)
        //                        if message.isSender {
        //                            Image("checkMark")
        //                                .resizable()
        //                                .frame(width:12, height:12)
        //                                .overlay {
        //                                    if message.isRead {
        //                                        Image("checkMark")
        //                                            .resizable()
        //                                            .frame(width:12, height:12)
        //                                            .padding(.leading,5)
        //                                    }
        //                                }
        //                                .padding(.trailing,4)
        //                        }
        //                    }
        //                }
        //
        //                .padding(-5)
        //        }
        //        .contextMenu(menuItems: {
        //            if message.isSender {
        //                Button {
        //                    viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
        //                } label: {
        //                    Text("Удалить".localize(language: viewModel.getLanguage()))
        //                }
        //            }
        //        })
        
        if message.isSender {
            VStack {
                if !message.attachmentLinks.isEmpty {
                    ForEach(0 ..< message.attachmentLinks.count, id:\.self) { i in
                        let link = message.attachmentLinks[i]
                        
                        CustomImageView(imageString: link, defaultImage: Image(systemName: "photo"))
                            .frame(width: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                }
                Text(message.text)
            }
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
                    Button {
                        Task {
                            await viewModel.removeMessage(messageId: message.id, chatId: message.chatId)
                        }
                    } label: {
                        Text("Удалить".localize(language: viewModel.getLanguage()))
                    }
                    
                })
            
        } else {
            VStack {
                if !message.attachmentLinks.isEmpty {
                    ForEach(0 ..< message.attachmentLinks.count, id:\.self) { i in
                        let link = message.attachmentLinks[i]
                        
                        CustomImageView(imageString: link, defaultImage: Image(systemName: "photo"))
                            .frame(width: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                }
                Text(message.text)
            }
                .foregroundStyle(.black)
                .font(.custom("Montserrat", size: 16))
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
                .overlay(alignment: .topLeading) {
                    
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
            
        }
        
    }
}

