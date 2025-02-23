//
//  TimerSheetImage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.01.2025.
//

import SwiftUI

struct TimerSheetImage: View {
    
    @State private var timerSheet: UIImage? // @State для хранения изображения
    
    let user: LocalUser
    let remainDays: Int
    let progress: (Double, Double)
    let image: Image
    
    

    init(user: LocalUser, remainDays: Int, progress: (Double, Double), image: Image) {
        self.user = user
        self.remainDays = remainDays
        self.progress = progress
        self.image = image
        
    }//0,4763033175 0,5794871795
    
    var body: some View {
        Group {
            if let timerSheet = timerSheet {
                Image(uiImage: timerSheet)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 1.9, height: UIScreen.main.bounds.height / 1.9)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .onAppear {
                        generateTimerSheet()
                    }
            }
        }
    }
    
    private func generateTimerSheet() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Переключаемся на главный поток для создания TimerSheet
            DispatchQueue.main.async {
                let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                let timerSheetView = TimerSheet(user: user, remainDays: remainDays,totalDays: HomeViewModel().totalProgress().0, progress: progress, image: image, isDMBStart: HomeViewModel().isDMBStart(), isDMBEnd: HomeViewModel().isDMBEnd())
                let renderedImage = timerSheetView.asUIImage(size: targetSize)
                
                // Обновляем состояние на главном потоке
                DispatchQueue.main.async {
                    self.timerSheet = renderedImage
                }
            }
        }
    }
}
