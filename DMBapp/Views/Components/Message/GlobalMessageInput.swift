//
//  GlobalMessageInput.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.09.2024.
//

import SwiftUI

struct GlobalMessageInput: View {
    
    @ObservedObject var viewModel:MessageViewModel
    @State var friend:Chat
    
    var sendMessage:(() -> Void)
    
    @State var text: String = ""
    @State private var textHeight: CGFloat = 0
            
    @FocusState var isKeyboardActive
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                .frame(height: 35)
            HStack {
                
                TextField("", text: $text, axis: .vertical)
                    .font(.custom("Montserrat", size: 16))
                    .foregroundStyle(.black)
                    .scrollContentBackground(.hidden)
                    .frame(height: 34)
                    .background(alignment: .leading) {
                        Text("Написать сообщение".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(isKeyboardActive || !text.isEmpty ? .clear : .gray)
                            .font(.custom("Montserrat", size: 16))
                            .focused($isKeyboardActive)
                            .padding(.leading, 5)
                            
                    }
                    .background(content: {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color(red: 230/255, green: 230/255, blue: 230/255))
                            .padding(.horizontal, -9)
                    })
                    .padding(.top, 5)
                    .padding(.leading)
                
                
                    Button {
                        if !text.isEmpty {
                            Task {
                                await viewModel.sendMessage(id: friend.chatId, text: text, images: [])
                            }
                            DispatchQueue.global(qos: .userInteractive).async {
                                text = ""
                                sendMessage()
                            }
                        }
                    } label: {
                        Image("enterMessageArrow")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding()
                    }
                
                
            }
            
        }
        .background(alignment: .top) {
            if !isKeyboardActive {
                
                
                Rectangle()
                    .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                    .frame(height: 100)
                    .padding(.top)
                
            }
        }
    }
}
