//
//  GlobalChatView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 18.09.2024.
//

import SwiftUI
import PhotosUI

struct GlobalChatView: View {
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
                            ForEach(viewModel.groupMessages?.messages ?? []) { message in
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
                                                
                                                Text("\(message.text)")
                                                    .font(.custom("Montserrat", size: 16))
                                                    .padding()
                                                    .foregroundStyle(.black)
                                                
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
                                                        .overlay(alignment: .topLeading, content: {
                                                            Text(message.senderName)
                                                                .foregroundStyle(Color(red:180/255, green:0,blue:0))
                                                                .font(.custom("Montserrat", size: 10))
                                                                .padding(.leading, 5)
                                                                .padding(.top, 2)
                                                        })
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
                        .onAppear {
                            viewModel.fetchGroupMessages(chatId: user.chatId)
                        }
                        
//                        ScrollView(.horizontal) {
//                            ForEach(0 ..< images.count, id: \.self) { num in
//
//                                Image(uiImage: images[num])
//                                    .resizable()
//                                    .scaledToFit()
//                                    .overlay(alignment: .topTrailing) {
//                                        Button {
//                                            images.remove(at: num)
//                                        } label: {
//                                            Circle()
//                                                .foregroundStyle(Color(red:242/255,green: 242/255, blue: 242/255))
//                                                .frame(width: 20)
//                                                .overlay {
//                                                    Image(systemName: "minus")
//                                                        .rotationEffect(.degrees(45))
//                                                        .foregroundStyle(.gray)
//                                                    Image(systemName: "minus")
//                                                        .rotationEffect(.degrees(-45))
//                                                        .foregroundStyle(.gray)
//
//                                                }
//                                        }
//
//                                    }
//                                    .frame(maxWidth: .infinity)
//                            }
//                            if isPresentVideosAndImages {
//                                VStack {
//                                    VStack(alignment:.leading) {
//                                        PhotosPicker(selection: $photoPickerItem, matching: .images, preferredItemEncoding: .automatic) {
//                                            Text("Фото")
//                                                .foregroundStyle(.black)
//                                                .font(.custom("Montserrat", size: 15))
//                                        }
//                                        .onChange(of: photoPickerItem) { val in
//                                            Task {
//                                                if let data = try? await val?.loadTransferable(type: Data.self) {
//                                                    guard let uiImage = UIImage(data: data) else { return}
//                                                    images.append(uiImage)
//
//                                                }
//                                            }
//                                        }
//                                        .padding(.bottom)
//                                        PhotosPicker(selection: $photoPickerItem, matching: .videos, preferredItemEncoding: .automatic) {
//                                            Text("Видео")
//                                                .foregroundStyle(.black)
//                                                .font(.custom("Montserrat", size: 15))
//                                        }
//
//                                    }
//                                    .background {
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
//                                            .padding(-5)
//                                    }
//                                    .padding(3)
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                        }
//                        .frame(height: 100)
                    GlobalMessageInput(viewModel: viewModel, friend: user)
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
                            
                            Button {
                                
                            } label: {
                                Spacer()
                                Text("\(user.name)")
                                    .foregroundStyle(.black)
                                    .font(.custom("benzin-extrabold", size: 18))
                                    .padding(.horizontal)
                                Spacer()
                                if let imageUrl = user.imageLink {
                                    CustomImageView(imageUrl: imageUrl)
                                        .frame(width: 39, height: 39)
                                } else {
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                        .frame(width: 39, height: 39)
                                        .clipShape(Circle())
                                    
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
    GlobalChatView(viewModel: MessageViewModel(), user: Chat(chatId: 0, name: "aaaa", imageLink: "", lastMessageText: "", lastMessageCreationTime: "", lastMessageSenderName: "", unreadMessagesAmount: 0, isGroupChat: false, isOnline: false))
}
