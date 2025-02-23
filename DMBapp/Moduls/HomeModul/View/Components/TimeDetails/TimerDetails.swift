//
//  TimerDetails.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.12.2024.
//

import SwiftUI

struct TimerDetails: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    @State var passedTime: (Int,Int,Int,Int)
    @State var leftTime: (Int,Int,Int,Int)
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default).autoconnect()
    
    init(viewModel:HomeViewModel) {
        self.viewModel = viewModel
        self.passedTime = viewModel.getPassedTime()
        self.leftTime = viewModel.getLeftTime()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Прошло всего")
                    .foregroundStyle(.white)
                    .font(.manrope(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 0) {
                    if viewModel.isDMBEnd() {
                        TimeTextFild(number: viewModel.totalProgress().0, time: .days)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().1, time: .hours)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().2, time: .minutes)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().3, time: .seconds)
                    } else if viewModel.isDMBStart() {
                        TimeTextFild(number: passedTime.0, time: .days)
                        Spacer()
                        TimeTextFild(number: passedTime.1, time: .hours)
                        Spacer()
                        TimeTextFild(number: passedTime.2, time: .minutes)
                        Spacer()
                        TimeTextFild(number: passedTime.3, time: .seconds)
                    } else {
                        TimeTextFild(number: 0, time: .days)
                        Spacer()
                        TimeTextFild(number: 0, time: .hours)
                        Spacer()
                        TimeTextFild(number: 0, time: .minutes)
                        Spacer()
                        TimeTextFild(number: 0, time: .seconds)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Осталось")
                    .foregroundStyle(.white)
                    .font(.manrope(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 0) {
                    if viewModel.isDMBEnd() {
                        TimeTextFild(number: 0, time: .days)
                        Spacer()
                        TimeTextFild(number: 0, time: .hours)
                        Spacer()
                        TimeTextFild(number: 0, time: .minutes)
                        Spacer()
                        TimeTextFild(number: 0, time: .seconds)
                    } else if viewModel.isDMBStart() {
                        TimeTextFild(number: leftTime.0, time: .days)
                        Spacer()
                        TimeTextFild(number: leftTime.1, time: .hours)
                        Spacer()
                        TimeTextFild(number: leftTime.2, time: .minutes)
                        Spacer()
                        TimeTextFild(number: leftTime.3, time: .seconds)
                    } else {
                        TimeTextFild(number: viewModel.totalProgress().0, time: .days)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().1, time: .hours)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().2, time: .minutes)
                        Spacer()
                        TimeTextFild(number: viewModel.totalProgress().3, time: .seconds)
                    }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.dmbBlack)
                .opacity(0.5)
        }
        .onAppear(perform: {
            passedTime = viewModel.getPassedTime()
            leftTime = viewModel.getLeftTime()
        })
        .onReceive(timer, perform: { timer in
            
            guard viewModel.isDMBStart() && !viewModel.isDMBEnd() else { return }
            
            print(1)
            // Уменьшаем оставшееся время
            var updatedLeftTime = leftTime
            var updatedPassedTime = passedTime
            
            if updatedLeftTime.3 > 0 {
                updatedLeftTime.3 -= 1
            } else {
                updatedLeftTime.3 = 59
                if updatedLeftTime.2 > 0 {
                    updatedLeftTime.2 -= 1
                } else {
                    updatedLeftTime.2 = 59
                    if updatedLeftTime.1 > 0 {
                        updatedLeftTime.1 -= 1
                    } else {
                        updatedLeftTime.1 = 23
                        if updatedLeftTime.0 > 0 {
                            updatedLeftTime.0 -= 1
                        }
                    }
                }
            }
            
            // Увеличиваем прошедшее время
            updatedPassedTime.3 += 1
            if updatedPassedTime.3 == 60 {
                updatedPassedTime.3 = 0
                updatedPassedTime.2 += 1
                if updatedPassedTime.2 == 60 {
                    updatedPassedTime.2 = 0
                    updatedPassedTime.1 += 1
                    if updatedPassedTime.1 == 24 {
                        updatedPassedTime.1 = 0
                        updatedPassedTime.0 += 1
                    }
                }
            }
            
            // Присваиваем новые значения, чтобы интерфейс обновился
            leftTime = updatedLeftTime
            passedTime = updatedPassedTime
            
        })
        
    }
}

#Preview {
    TimerDetails(viewModel: HomeViewModel())
}
