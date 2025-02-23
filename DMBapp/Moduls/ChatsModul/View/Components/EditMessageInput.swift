//
//  EditMessageInput.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 05.01.2025.
//

import SwiftUI

struct EditMessageInput: View {
    
    @ObservedObject var viewModel:ChatsViewModel
    @Binding var text:String
    var chatId:String
    @Binding var editMessage:Message?
    
    var cancelComplition: () -> () = {}
    var clipComplition: () -> () = {}
    
    var body: some View {
        VStack {
            HStack {
                
                VStack(alignment: .leading) {
                    Text(editMessage?.text ?? "")
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
            .onAppear {
                text = editMessage?.text ?? ""
            }
            
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
                        if let editMessage = editMessage {
                            viewModel.editMessage(messageId: editMessage.id, text: text)
                            text = ""
                        }
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
