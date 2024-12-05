//
//  MessageInput.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.08.2024.
//

import Foundation
import SwiftUI
import PhotosUI

struct MessageInput: View {
    
    @ObservedObject var viewModel:MessageViewModel
    
    var sendMessage:(() -> Void)
    
    @State var friend:Chat
    
    @State var text: String = ""
    @State private var textHeight: CGFloat = 0
    
    @Binding var isPresentVideosAndImages:Bool
    @Binding var images:[UIImage]
    
    @State var photoPickerItem:PhotosPickerItem?
    @Binding var isImageSizeBig:Bool
    
    @FocusState var isKeyboardActive
        
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                .frame(height: 35)
            HStack {
          
                PhotosPicker(selection: $photoPickerItem, matching: .images, preferredItemEncoding: .automatic) {
                    Image(systemName: "paperclip")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.black)
                        .padding()
                }
                .onChange(of: photoPickerItem) { val in
                    Task {
                        if let data = try? await val?.loadTransferable(type: Data.self) {
                            guard let uiImage = UIImage(data: data) else { return }
                            if calculateImageSize(image: uiImage) {
                                images.append(uiImage)
                            } else {
                                isImageSizeBig = true
                            }
                        }
                    }
                }
//                .alert("Картинка весит больше 10 МБ. Пожалуйста выберите другую картинку", isPresented: $isImageSizeBig, actions: {
//                    Button("OK", role: .cancel) {}
//                })
                .disabled(images.count == 10)

//                Button {
//                    withAnimation {
//                        isPresentVideosAndImages.toggle()
//                    }
//                    
//                } label: {
////                    if isPresentVideosAndImages {
////                        Image(systemName: "cross")
////                            .resizable()
////                            .frame(width: 16, height: 16)
////                            .foregroundStyle(.black)
////                            .rotationEffect(.degrees(45))
////                            .padding()
////                    } else {
//                        Image(systemName: "paperclip")
//                            .resizable()
//                            .frame(width: 16, height: 16)
//                            .foregroundStyle(.black)
//                            .padding()
////                    }
//                }
                


                
                
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
                
                
                    Button {
                        if !text.isEmpty || !images.isEmpty {
                            print(text, images)
                            viewModel.sendMessage(id: friend.chatId, text: text, images: images)
                            
                            text = ""
                            images.removeAll()
                            sendMessage()
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
    
    func calculateImageSize(image: UIImage) -> Bool {
        
        guard let data = image.pngData() else { return false }
        if data.count >= 10000000 {
            return false
        }
        
        return true
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//#Preview(traits:.sizeThatFitsLayout) {
//    MessageInput(viewModel: MessageViewModel(), friend: Chat(chatId: 0, name: "", isGroupChat: true, isOnline: true))
//}
