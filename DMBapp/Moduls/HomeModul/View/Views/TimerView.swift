//
//  TimerView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import SwiftUI
import BottomSheet

struct TimerView: View {
    
    @State private var animateGradient = false
    @State var color:Color = .init(red: 200/255, green: 211/255, blue: 109/255)
    
    @StateObject var viewModel = HomeViewModel()
    
    @Binding var bottomSheetPosition:BottomSheetPosition
    
    @State var isFullShow = false
    
    @Binding var isShowTabView:Bool
    
    var upcomingEventComplition: () -> () = {}
    
    var body: some View {
        VStack(spacing: bottomSheetPosition == .relative(0.3) ? UIScreen.main.bounds.height * 0.01 : UIScreen.main.bounds.height * 0.02369668246) {
            
            ProcentTextField(viewModel:viewModel, isFullShow: isFullShow)
            
            ProgressLine(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.horizontal)
            
            if !isFullShow {
                Text("Смахни вверх, чтобы увидеть детали")
                    .foregroundStyle(.white)
                    .opacity(0.2)
                    .padding(.horizontal)
                    .font(.manrope(size: 12))
            } else {
                VStack(spacing: bottomSheetPosition == .relative(0.3) ? UIScreen.main.bounds.height * 0.01 : UIScreen.main.bounds.height * 0.02369668246) {
                if viewModel.isDMBEnd() {
                    Text("Поздравляем с ДМБ!")
                        .foregroundStyle(.white)
                        .font(.manrope(size: 18, weight: .bold))
                } else {
                    Text(viewModel.getUserName())
                        .foregroundStyle(.white)
                        .font(.manrope(size: 18, weight: .bold))
                        .opacity(0.5)
                    
                }
                
                TimerDetails(viewModel: viewModel)
                
                UpcomingEventBar(viewModel: viewModel, upcomingEventComplition: {
                    upcomingEventComplition()
                })
                
                
                NavigationLink {
                    ShareTimerView(viewModel: viewModel, isShowTabView: $isShowTabView)
                        .navigationBarBackButtonHidden()
                } label: {
                    Capsule()
                        .frame(height: UIScreen.main.bounds.height * 0.067)
                        .foregroundStyle(.white)
                        .overlay {
                            Text("Поделиться таймером")
                                .foregroundStyle(Color.dmbRed)
                                .font(.system(size: 18, weight: .medium))
                        }
                }
                
            }
                
            }
            
            Spacer()
        }
       
        .onChange(of: bottomSheetPosition) { position in
            if bottomSheetPosition == .relative(0.3) {
                isFullShow = false
            } else {
                isFullShow = true
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
//        .background {
//            if bottomSheetPosition != .relative(0.2914691943) {
//                RoundedRectangle(cornerRadius: 30)
//                    .trim(from: 0.0, to: 0.5) // Оставляем только верхнюю половину круга
//                    .stroke(
//                        LinearGradient(
//                            gradient: Gradient(colors: [color.opacity(0.3), color, color.opacity(0.3)]),
//                            startPoint: animateGradient ? .leading : .bottomTrailing,
//                            endPoint: animateGradient ? .trailing : .leading
//                        ),
//                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
//                    )
//                    .padding(.horizontal)
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7369668246)
//                
//                    .rotationEffect(.degrees(180))
//                    .onAppear {
//                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
//                            animateGradient.toggle()
//                        }
//                    }
//            }
//        }
    }
}



#Preview {
    TimerView(bottomSheetPosition: .constant(.relative(0.9)), isShowTabView: .constant(false))
        .background {
            Color.gray
        }
        .colorScheme(.dark)
}
