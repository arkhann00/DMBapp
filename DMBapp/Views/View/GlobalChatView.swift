//
//  GlobalChatVie.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 29.11.2024.
//

import SwiftUI

struct GlobalChatView: View {
    
    @ObservedObject var viewModel:MessageViewModel
    private let userDefaults = UserDefaultsManager.shared
    
    @State var chat:Chat
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.fetchMessagesStatus = true
                    dismiss()
                } label: {
                    Image("BlackArrow")
                        .resizable()
                        .frame(width: 23, height: 22)
                }
                .rotationEffect(.degrees(180))
                .padding(.trailing)
                
                Spacer()
                Button {
                    
                } label: {
                    Text("\(chat.name)")
                        .foregroundStyle(.black)
                        .font(.custom("benzin-extrabold", size: 18))
                        .padding(.horizontal)
                }
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Rectangle().foregroundStyle(.white).ignoresSafeArea())
            
            Spacer()
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages.indices, id: \.self) { i in
                            GroupMessageView(viewModel: viewModel, message: viewModel.messages[i])
                                .id(viewModel.messages[i].id)
                        }
                    }
                    .onChange(of: viewModel.viewState) { val in
                        switch val {
                        case .successFetchMorePartOfMessages:
                            scrollViewProxy.scrollTo(viewModel.lastMessageId, anchor: .top)
                        case .successFetchFirstPartOfMessages:
                            scrollViewProxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        default:
                            break
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchPartOfMessages(chatId: chat.chatId)
                }
                
            }
            
            Spacer()
            
            GlobalMessageInput(viewModel: viewModel, friend: chat) {}
        }
        .onAppear(perform: {
            Task {
                await viewModel.fetchPartOfMessages(chatId: chat.chatId)
            }
        })
        .background {
            viewModel.getBackgroundImage()
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.6))
                .frame(maxWidth: .infinity)
        }
        
    }
}

