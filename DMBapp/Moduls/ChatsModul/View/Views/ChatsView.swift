//
//  MessageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import SwiftUI

struct ChatsView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    @Binding var isShowTabView:Bool
    @State var isPresentGeneralChat = false
    
    @Binding var completion: () -> ()
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Чаты")
                    .foregroundStyle(.black)
                    .font(.system(size: 48, weight: .bold))
                    .frame(alignment: .leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                ScrollView {
                    if let globalChat = viewModel.globalChat {
                        NavigationLink {
                            GeneralChatView(viewModel: viewModel, chat: globalChat, isShowTabView: $isShowTabView, completion: $completion)
                                .navigationBarBackButtonHidden()
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            GeneralChatCell(globalChat: globalChat)
                                .padding(.vertical)
                                
                        }
                        .padding(.horizontal)
  
                        
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchGlobalChat()
                    }
                }
                
                if !viewModel.isAuthorizedUser() {
                    Button {
                        completion()
                    } label: {
                        RoundedRectangle(cornerRadius: 31)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.dmbRed)
                            .frame(height: 61)
                            .overlay {
                                Text("Зарегистрироваться")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .medium))
                            }
                    }
                    .padding()
                    .padding(.bottom)
                    .padding(.bottom)
                }
            
            }
            .frame(maxWidth: .infinity)
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            .colorScheme(.light)
            .onAppear {
                isShowTabView = true
                Task {
                    await viewModel.fetchGlobalChat()
                }
                
            }
            
            
        
    }
}

#Preview {
    ChatsView(isShowTabView: .constant(true), completion: .constant({
        
    }))
}
