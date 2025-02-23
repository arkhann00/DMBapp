//
//  MessageAttachmentsView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.01.2025.
//

import SwiftUI

struct MessageAttachmentsView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel:ChatsViewModel
    var chatId:String
    var replyMessage:Message?
    
    @State private var timerSheet: UIImage?
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("Назад")
                        .foregroundStyle(Color.dmbGray)
                        .font(.manrope(size: 16))
                }
                
                Spacer()
                
                Text("Выбор фото")
                    .foregroundStyle(.black)
                    .font(.manrope(size: 18, weight: .bold))
                
                Spacer()
                Spacer()
            }
            
            Button {
                if let timerSheet = timerSheet {
                    viewModel.sendMessage(id: chatId, text: "", images: [timerSheet], replyToId: replyMessage?.id)
                    dismiss()
                }
            } label: {
                TimerSheetImage(user: HomeViewModel().getUser(), remainDays: HomeViewModel().getRemainingDays(), progress: HomeViewModel().getProgressRelation(), image: HomeViewModel().getBackgroundImage())
            }
            
            
            Spacer()
        }
        .padding()
        .background {
            Color.white.ignoresSafeArea()
        }
        .onAppear {
            generateTimerSheet()
        }
    }
    
    private func generateTimerSheet() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Переключаемся на главный поток для создания TimerSheet
            DispatchQueue.main.async {
                let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                let timerSheetView = TimerSheet(user: HomeViewModel().getUser(), remainDays: HomeViewModel().getRemainingDays(), totalDays: HomeViewModel().totalProgress().0, progress: HomeViewModel().getProgressRelation(), image: HomeViewModel().getBackgroundImage(), isDMBStart: HomeViewModel().isDMBStart(), isDMBEnd: HomeViewModel().isDMBEnd())
                let renderedImage = timerSheetView.asUIImage(size: targetSize)
                
                // Обновляем состояние на главном потоке
                DispatchQueue.main.async {
                    self.timerSheet = renderedImage
                }
            }
        }
    }
}
