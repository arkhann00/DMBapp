//
//  GeneralChatBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

struct GeneralChatBar: View {
    
    @Binding var isShowTabView:Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button {
                isShowTabView = true
                dismiss()
            } label: {
                Image(Images.leadingArrow())
                    .resizable()
                    .frame(width: 12, height: 12)
                Text("Назад")
                    .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
            }
            
            Spacer()
            
            Text("Общий чат")
                .foregroundStyle(.black)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            Image(Images.redStar())
                .resizable()
                .frame(width: 40, height: 40)
            
        }
        .padding()
        .overlay(alignment:.bottom) {
            Divider()
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
}

