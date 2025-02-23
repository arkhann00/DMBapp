//
//  ReplyMessageInput.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 04.01.2025.
//

import SwiftUI

struct ReplyMessageInput: View {
    
    @ObservedObject var viewModel:ChatsViewModel
    @Binding var text:String
    var chatId:String
    @Binding var replyMessage:Message?
    
    var cancelComplition: () -> () = {}
    var clipComplition: () -> () = {}
    
    var body: some View {
        VStack {
            HStack {
                
                VStack(alignment: .leading) {
                    Text("@\(replyMessage?.senderNickname ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.dmbGray)
                        .font(.manrope(size: 14, weight: .medium))
                    Text(replyMessage?.text ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.dmbBlack)
                        .font(.manrope(size: 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.dmbWhite
                }
                Button {
                    cancelComplition()
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.black)
                }
                
            }
            
            HStack {
                Button {
                    
                } label: {
                    Image(Images.messageClip())
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(Color.dmbWhite)
                        }
                }
                
                TextField("", text: $text, axis: .vertical)
                    .font(.manrope(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .padding()
                    .background {
                        
                        RoundedRectangle(cornerRadius: 21)
                            .foregroundStyle(Color.dmbWhite)
                        if text.isEmpty {
                            Text("Сообщение")
                                .font(.manrope(size: 14, weight: .medium))
                                .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }
                        
                    }
                
                Button {
                    if !text.isEmpty {
                        viewModel.sendMessage(id: chatId, text: text, images: [], replyToId: replyMessage?.id)
                    }
                } label: {
                    
                    text.isEmpty ? Image(Images.topArrow())
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(Color.dmbWhite)
                        }
                    :
                    Image(Images.whiteTopArrow())
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(.black)
                        }
                    
                }
                
            }
        }
        .ignoresSafeArea()
        .padding(.horizontal)
        .padding(.top)
        .overlay(alignment: .top) {
            Divider()
        }
        
    }
}
