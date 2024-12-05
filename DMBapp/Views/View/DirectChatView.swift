//
//  FriendChatView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 22.08.2024.
//

import SwiftUI
import PhotosUI

struct DirectChatView: View {
    @ObservedObject var viewModel:MessageViewModel
    private let userDefaults = UserDefaultsManager.shared
    private let networkManager = NetworkManager()
    
    @State var user:Chat
    @State var directChatData:DirectChatData?
    @State var isBackgroundDim = false
    
    @State var photoPickerItem:PhotosPickerItem?
    
    @State var images:[UIImage] = []
    
    @State var isShowFastScrollButton = false
    
    @State var isEditingMessage = false
    @State var isPresentVideosAndImages = false
    
    @State var isImageSizeBig = false
    
    @Environment(\.dismiss) var dismiss
    
    init(viewModel:MessageViewModel, user:Chat) {
        self.viewModel = viewModel
        self.user = user
        
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollViewReader { scrollViewProxy in
                
                    
                        HStack {
                            Button {
                                dismiss()
                                viewModel.messages.removeAll()
                                viewModel.loadingMessages.removeAll()
                            } label: {
                                Image("BlackArrow")
                                    .resizable()
                                    .frame(width: 23, height: 22)
                            }
                            .rotationEffect(.degrees(180))
                            .padding(.trailing)
                            if let directChatData = directChatData {
                                Spacer()
                                NavigationLink {
                                    UserCardView(userId: directChatData.id, viewModel: HomeViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Text("\(directChatData.name)")
                                        .foregroundStyle(.black)
                                        .font(.custom("Montserrat", size: 17))
                                }
                                Spacer()
                                NavigationLink {
                                    UserCardView(userId: directChatData.id, viewModel: HomeViewModel())
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    CustomImageView(imageString: directChatData.chatImageLink, defaultImage: Image(systemName: "person.fill"))
                                        .foregroundStyle(.black)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                    
                                }
                            } else {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .background {
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(height: 100)
                                .ignoresSafeArea()
                        }
                ScrollView {
                    GeometryReader { geometry -> Color in
                        let minY = geometry.frame(in: .global).minY
                        
                        if minY > 50 {
                            DispatchQueue.global(qos: .background).async {
                                viewModel.fetchPartOfMessages(chatId: user.chatId, lastMessageId: viewModel.messages.first?.id)
                            }
                        }
                        
                        return Color.clear
                    }
                    .frame(height: 1)
                    VStack {
                        if viewModel.messages.count < 10 {
                            ForEach(0...12 - viewModel.messages.count, id:\.self) { i in
                                
                                Rectangle()
                                    .frame(height: 40)
                                    .foregroundStyle(.clear)
                                
                            }
                        }
                        ForEach(0 ..< viewModel.messages.count, id:\.self) { num in
                            let message = viewModel.messages[num]
                            HStack {
                                if message.isSender {
                                    Spacer()
                                }
                                DirectMessageView(viewModel: viewModel,message: message)
                                    .padding(.vertical,4)
                                    .padding(.horizontal)
                                
                                if !message.isSender {
                                    Spacer()
                                }
                                
                            }
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                            .id(num)
                            .onAppear {
                                scrollViewProxy.scrollTo(viewModel.messages.indices.last, anchor: .bottom)
                                
                                
                            }
                        }
                        
                        ForEach(0 ..< viewModel.loadingMessages.count, id: \.self) { i in
                            let loadingMessage = viewModel.loadingMessages[i]
                            HStack {
                                Spacer()
                                VStack {
                                    
                                    if !loadingMessage.image.isEmpty {
                                        ForEach(0 ..< loadingMessage.image.count, id:\.self) { i in
                                            Image(uiImage: loadingMessage.image[i])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 250)
                                            
                                        }
                                    }
                                    
                                    Text("\(loadingMessage.text)")
                                        .font(.custom("Montserrat", size: 16))
                                        .padding()
                                        .foregroundStyle(.black)
                                        .frame(alignment:.leading)
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(red:211/255, green: 211/255, blue: 211/255))
                                        .overlay(alignment: .bottomTrailing) {
                                            Image(systemName: "clock")
                                                .foregroundStyle(.black)
                                                .opacity(0.5)
                                                .font(.custom("Montserrat", size: 9))
                                                .padding(.trailing,3)
                                                .padding(.bottom, 5)
                                        }
                                        .padding(-5)
                                    
                                    
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .id(i)
                            .onAppear {
                                scrollViewProxy.scrollTo(viewModel.messages.indices.last, anchor: .bottom)
                                
                                
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                    
                }
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity)
                .overlay(alignment: .bottomLeading) {
                    ScrollView(.horizontal) {
                        ForEach(0 ..< images.count, id: \.self) { num in
                            
                            Image(uiImage: images[num])
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        images.remove(at: num)
                                    } label: {
                                        Circle()
                                            .foregroundStyle(Color(red:242/255,green: 242/255, blue: 242/255))
                                            .frame(width: 20)
                                            .overlay {
                                                Image(systemName: "minus")
                                                    .rotationEffect(.degrees(45))
                                                    .foregroundStyle(.gray)
                                                Image(systemName: "minus")
                                                    .rotationEffect(.degrees(-45))
                                                    .foregroundStyle(.gray)
                                                
                                            }
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity)
                        }
                        
                    }
                    .frame(height: 100)
                    
                }
                MessageInput(viewModel: viewModel, sendMessage: {
                    scrollViewProxy.scrollTo(viewModel.messages.indices.last, anchor: .bottom)
                },friend: user, isPresentVideosAndImages: $isPresentVideosAndImages, images: $images, isImageSizeBig: $isImageSizeBig)
                
            }
            
            
            
            
            
            
            
        }
        .overlay(content: {
            if isImageSizeBig == true {
                BigSizeImageError(isPresented: $isImageSizeBig)
            }
        })
        .background(content: {
            
            viewModel.getBackgroundImage()
                .resizable()
                .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                .frame(maxWidth: .infinity)
                .scaledToFill()
                .ignoresSafeArea()
                
        })
        .onAppear(perform: {
            viewModel.readAllMessages(chatId: user.chatId)
            isBackgroundDim = viewModel.getIsDimBackground()
            viewModel.fetchPartOfMessages(chatId: user.chatId, lastMessageId: nil)
            viewModel.fetchMessagesStatus = true
            
            networkManager.fetchDirectChatData(chatId: user.chatId) { response in
                switch response.result {
                case .success(let directChat):
                    self.directChatData = directChat
                    print("SUCCESS fetchDirectChatData")
                case .failure(_):
                    print("FAILURE fetchDirectChatData: \(response)")
                    response.printJsonError()
                }
            }
        })
        
    }
    


}
