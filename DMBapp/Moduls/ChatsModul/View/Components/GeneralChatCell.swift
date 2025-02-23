//
//  GeneralChat.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

struct GeneralChatCell: View {
    
    var globalChat:Chat
    
    var body: some View {
        HStack {
            
            Image(Images.redStar())
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                
                Text("Общий чат")
                    .foregroundStyle(.black)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Text("\(globalChat.lastMessageSenderName ?? "")")
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .regular))
                
                Text("\(globalChat.lastMessageText ?? "")")
                    .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                    .font(.system(size: 12, weight: .regular))
                    
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let unreadMessagesAmount = globalChat.unreadMessagesAmount, unreadMessagesAmount > 0 {
                    Text("\(unreadMessagesAmount)")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                        .font(.system(size: 12, weight: .regular))
                        .padding(4)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.dmbWhite)
                        }
                }
                Spacer()
                
                Text("\(globalChat.lastMessageCreationTime ?? "")")
                    .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                    .font(.system(size: 12, weight: .regular))
                
            }
            
        }
        .frame(height: 60)
        .background {
            Color.white.ignoresSafeArea()
        }
    }
}

#Preview {
    GeneralChatCell(globalChat: Chat(chatId: "", name: "aaaaa", imageLink: "nil", lastMessageText: "nil", lastMessageCreationTime: "nil", lastMessageSenderName: "nil", unreadMessagesAmount: 2, chatType: "", isOnline: false))
}
