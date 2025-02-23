//
//  MessageInput.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

struct SendMessageInput: View {
    
    @ObservedObject var viewModel:ChatsViewModel
    @Binding var text:String
    
    var chatId:String
    var clipComplition: () -> () = {}
        
    var body: some View {
        HStack {
            Button {
                clipComplition()
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
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .padding()
                .background {
                    
                    RoundedRectangle(cornerRadius: 21)
                        .foregroundStyle(Color.dmbWhite)
                    if text.isEmpty {
                        Text("Сообщение")
                            .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                    
                }
            
            Button {
                if !text.isEmpty {
                    viewModel.sendMessage(id: chatId, text: text, images: [], replyToId: "")
                    text = ""
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
                : Image(Images.whiteTopArrow())
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding()
                    .background {
                        Circle()
                            .foregroundStyle(.black)
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
