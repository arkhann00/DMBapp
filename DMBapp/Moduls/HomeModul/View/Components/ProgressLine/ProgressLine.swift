//
//  ProgressLine.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.12.2024.
//

import SwiftUI
import Combine

struct ProgressLine: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()
    @State var cancellable: AnyCancellable?
    
    @State var process:(Double, Double) = (50,200)
    
    let a = 150
    
    @State var event:Event?
        
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 40)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7948717949)
                .frame(height: UIScreen.main.bounds.height * 0.009478672986)
                .foregroundStyle(.white)
                .opacity(0.2)
            
            if viewModel.isDMBStart() || viewModel.isDMBEnd() {
                HStack {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: process.0 < process.1 ? UIScreen.main.bounds.width * 0.7948717949 * (process.0 / process.1) : UIScreen.main.bounds.width * 0.7948717949, height: UIScreen.main.bounds.height * 0.009478672986)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 1)
                }
            }
            
            if let event = event, let eventDate = event.date, let endDate = viewModel.getEndDate(), let startDate = viewModel.getStartDate() {
                HStack {
                    Spacer()
                    Image(Images.redStar())
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7948717949 * (Double(eventDate.timeIntervalSince(startDate)) / endDate.timeIntervalSince(startDate)))
                .onAppear {
                    print(eventDate.timeIntervalSince(startDate), process.1, process.0)
                }
            }
                
        }
        .onReceive(timer, perform: { _ in
            
            guard viewModel.isDMBStart() && !viewModel.isDMBEnd() else { return }
            
            if (process.0 < process.1) {
                process.0+=1
            }
            else {
                cancellable = timer.sink { _ in }
                cancellable?.cancel()
            }
        })
        .onAppear {
            process = viewModel.getProgressRelation()
            event = viewModel.findNearestEvent()
            print(viewModel.findNearestEvent())
            
            print(process, Double(event?.date?.timeIntervalSince(Date.now) ?? 0))
        }
    }
}

#Preview {
    ProgressLine(viewModel: HomeViewModel())
}
