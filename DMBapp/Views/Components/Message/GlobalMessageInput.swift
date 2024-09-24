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
    
    @State var text: String = ""
    @State private var textHeight: CGFloat = 0
            
    @FocusState var isKeyboardActive
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                .frame(height: 35)
            HStack {
                
                TextEditor(text: $text)
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
                            viewModel.sendMessage(id: friend.chatId, text: text, images: [])
                            text = ""
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
        
//        ZStack(alignment: .leading) {
//            // Примерный текст, чтобы определить высоту
//            Text(text)
//                .font(.body)
//                .foregroundColor(.clear)
//                .padding(8)
//                .background(GeometryReader { geometry in
//                    Color.clear
//                        .preference(key: ViewHeightKey.self, value: geometry.size.height)
//                })
//
//            // Текстовый редактор
//            TextEditor(text: $text)
//                .frame(height: max(40, textHeight)) // минимальная высота 40
//                .padding(8)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .onPreferenceChange(ViewHeightKey.self) { height in
//                    textHeight = height
//                }
//        }
    }
}
