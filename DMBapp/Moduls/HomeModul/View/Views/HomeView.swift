//
//  HomeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import SwiftUI
import BottomSheet

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var timerManager = TimerManager()
    
    @State var bottomSheetPosition:BottomSheetPosition = .relative(0.3)
    
    @Binding var isShowTabView:Bool
    
    var upcomingEventComplition: () -> () = {}
    
    @State var isBackgroundDim = false
    @State var backgroundImage = Image("DefaultBackground")
    
    @State var isPresentShareTimerView = false
    
    var body: some View {
            ZStack {
                
            }
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition, switchablePositions: [.relative(0.3), .relativeTop(0.82)]) {
                
                TimerView(bottomSheetPosition: $bottomSheetPosition, isShowTabView: $isShowTabView) {
                    upcomingEventComplition()
                }
                
                
            }
            .background {
                backgroundImage
                    .resizable()
                    .scaledToFill() // Заполняет экран, обрезая лишнее
                    .edgesIgnoringSafeArea(.all)
                    .overlay {
                        if isBackgroundDim {
                            Color.black.opacity(0.5)
                                .ignoresSafeArea()
                        }
                    }
            }
            .onChange(of: isPresentShareTimerView) { val in
                
                print(val)
                
            }
            .colorScheme(.dark)
            .onAppear {
                isBackgroundDim = viewModel.getIsDimBackground()
                backgroundImage = viewModel.getBackgroundImage()
            }
            
        
        
       
    }
}

#Preview {
    HomeView(isShowTabView: .constant(true))
}
