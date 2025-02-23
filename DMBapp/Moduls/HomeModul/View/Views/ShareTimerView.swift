//
//  ShareTimerView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 27.12.2024.
//

import SwiftUI
struct ShareTimerView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    @Binding var isShowTabView:Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State var isShareTimer = false
    
    @State var timerSheet:UIImage?
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    dismiss()
                    isShowTabView = true
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 20, height: 19)
                    Text("Назад")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                }
                VStack(alignment: .leading,spacing: 0) {
                    Text("Поделиться")
                        .font(.custom("Manrope-Bold", size: 48))
                        .frame(alignment: .leading)
                        .foregroundStyle(.black)
                    Text("таймером")
                        .font(.custom("Manrope-Bold", size: 48))
                        .frame(alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.top, -20)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            TimerSheetImage(user: viewModel.getUser(), remainDays: viewModel.getRemainingDays(), progress: viewModel.getProgressRelation(), image: viewModel.getBackgroundImage())
                .shadow(radius: 20)
                
            Spacer()
            
            VStack {
                HStack {
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 81,height: 61)
                            .foregroundStyle(Color(red: 0, green: 119/255, blue: 1))
                            .overlay {
                                Image(Images.vkLogo())
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                    }
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 81, height: 61)
                            .foregroundStyle(.white)
                            .shadow(radius: 1)
                            .overlay {
                                Image(Images.instagramLogo())
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                    }
                    
                    
                    Button {
                        if let timerSheet = timerSheet {
                            let image = Image(uiImage: timerSheet).clipShape(RoundedRectangle(cornerRadius: 10))                            
                            shareToTelegram(image: timerSheet)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 81, height: 61)
                            .foregroundStyle(Color(red: 55/255, green: 174/255, blue: 226/255))
                            .overlay {
                                Image(Images.telegramLogo())
                                    .resizable()
                                    .frame(width: 38, height: 32)
                            }
                    }
                   
                    Button {
                        isShareTimer = true
                    } label: {
                        Image(Images.other())
                            .resizable()
                            .frame(width: 81, height: 61)
                    }
                    .sheet(isPresented: $isShareTimer) {
                        if let timerSheet = timerSheet {
                            TimerActivityViewController(image: timerSheet)
                                .presentationDetents([.medium])
                        }
                    }
                    
                }
                
                RedButton(text: "Отправить в общий чат") {}
                    .frame(width: 355)
            }
            
        }
        .frame(maxWidth: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .padding(.horizontal)
        .padding(.top)
        .background {
            Color.white.ignoresSafeArea()
        }
        .onAppear {
            isShowTabView = false
            timerSheet = viewModel.shareTimerImage()
            
        }
        .onDisappear {
            isShowTabView = true
        }
        
        
    }
    
    
    private func shareToTelegram(image: UIImage) {
            guard let jpegData = image.jpegData(compressionQuality: 1.0) else { return }

            // Сохраняем во временную директорию (чтобы передать URL, а не сам UIImage)
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("tempImage.jpg")
            do {
                try jpegData.write(to: tempURL)
            } catch {
                print("Ошибка сохранения файла: \(error)")
                return
            }
            
            // Создаём контроллер
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            // Можно исключить все стандартные типы (почта, сообщения, и т.д.)
            activityVC.excludedActivityTypes = [
                .mail,
                .message,
                .addToReadingList,
                .airDrop,
                .assignToContact,
                .copyToPasteboard,
                .markupAsPDF,
                .postToFacebook,
                .postToFlickr,
                .postToTencentWeibo,
                .postToTwitter,
                .postToVimeo,
                .postToWeibo,
                .saveToCameraRoll,
                .print
            ]
            
            // Презентуем контроллер
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        }
    
    
        
}

#Preview {
    ShareTimerView(viewModel: HomeViewModel(), isShowTabView: .constant(false))
}
