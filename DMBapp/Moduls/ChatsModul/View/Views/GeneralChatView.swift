//
//  GeneralChatView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

enum MessageInputState {
    case send
    case edit
    case reply
}

struct GeneralChatView: View {
    
    @ObservedObject var viewModel: ChatsViewModel
    @State var chat: Chat
    
    @State var replyToMessage: Message?
    @State var editMessage: Message?
    @State var text:String = ""
    
    @Binding var isShowTabView:Bool
    
    @State var isAttachmentVisible:Bool = false
    
    @State var messageInputState:MessageInputState = .send
    
    @Binding var completion: () -> ()
    
    var body: some View {
        
       
        ScrollViewReader { scrollViewProxy in
            VStack(spacing: 0) {
                GeneralChatBar(isShowTabView: $isShowTabView)
                ScrollView {
                    
                    VStack {
                        
                        ForEach(viewModel.messages.indices, id: \.self) { i in
                            
                            GlobalMessageCell(viewModel: viewModel, message: viewModel.messages[i], replyComplition: {
                                withAnimation {
                                    replyToMessage = viewModel.messages[i]
                                    messageInputState = .reply
                                }
                            }, editComplition: {
                                withAnimation {
                                    editMessage = viewModel.messages[i]
                                    messageInputState = .edit
                                }
                            }, replyMessageTap: { id in
                                withAnimation {
                                    scrollViewProxy.scrollTo(id)
                                }
                                
                            })
                            .id(viewModel.messages[i].id)
                            .padding(.horizontal, 2)
                        }
                        
                        Color.clear.frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.viewState) { state in
                        
                        switch state {
                            
                        case .successFetchMorePartOfMessages:
                            scrollViewProxy.scrollTo(viewModel.messages[11].id, anchor: .top)
                            
                        case .successFetchFirstPartOfMessages:
                            scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                            
                        case .successSentMessage:
                            scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                            text = ""
                            messageInputState = .send
                            
                        case .successEditMessage:
                            messageInputState = .send
                            text = ""
                            Task {
                                await viewModel.fetchPartOfMessages(chatId: chat.chatId)
                            }
                        default:
                            break
                            
                        }
                        
                    }
                    .onChange(of: viewModel.countOfImages) { count in
                        if viewModel.messages.count <= 10 {
                            scrollViewProxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                        
                    }
                    .padding(.vertical)
                    
                }
                
                .refreshable {
                    Task {
                        await viewModel.fetchPartOfMessages(chatId: chat.chatId)
                    }
                }
                .sheet(isPresented: $isAttachmentVisible) {
                    MessageAttachmentsView(viewModel: viewModel, chatId: chat.chatId, replyMessage: replyToMessage)
                        .presentationDetents([.medium])
                }
                
                if viewModel.isAuthorizedUser() {
                    switch messageInputState {
                    case .send:
                        SendMessageInput(viewModel: viewModel, text: $text ,chatId: chat.chatId, clipComplition : {
                            isAttachmentVisible = true
                        })
                        .colorScheme(.light)
                    case .edit:
                        EditMessageInput(viewModel: viewModel, text: $text, chatId: chat.chatId, editMessage: $editMessage, cancelComplition: {
                            withAnimation {
                                messageInputState = .send
                            }
                        },clipComplition: {
                            isAttachmentVisible = true
                        })
                    case .reply:
                        ReplyMessageInput(viewModel: viewModel, text: $text, chatId: chat.chatId, replyMessage: $replyToMessage, cancelComplition: {
                            
                            withAnimation {
                                messageInputState = .send
                            }
                        }, clipComplition: {
                            isAttachmentVisible = true
                        })
                    }
                } else {
                    RedButton(text: "Зарегистрироваться") {
                        completion()
                    }
                    .padding(.horizontal)
                }
                
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .frame(maxWidth: .infinity)
        .onAppear {
            
            isShowTabView = false
            Task {
                await viewModel.readAllMessages(chatId: chat.chatId)
                if viewModel.isAuthorizedUser() {
                    await viewModel.fetchPartOfMessages(chatId: chat.chatId)
                } else {
                    await viewModel.fetchUnregisteredGlobalChat()
                }
            }
        }
    
        .onDisappear {
            isShowTabView = true
            viewModel.countOfImages = 0
            viewModel.messages.removeAll()
        }
    }
    
    
}

