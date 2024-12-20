//
//  ProgressView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI
import Combine

struct ProgressLineView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()
    
    @State var numerator:Double = 0
    @State var denominator:Double = 0
  
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                .frame(width: 352*(numerator/denominator), height: 30)
            
            TextField("", text: .constant("\((numerator/denominator*100).roundedForNums(for: 6))%"))
                .multilineTextAlignment(.center)
                .font(.custom("benzin-extrabold", size: 12))
                .frame(maxWidth: .infinity)
                .disabled(true)
                .foregroundStyle(.black)
                .onReceive(timer, perform: { _ in
                    if (numerator <= denominator) {
                        numerator+=1
                    }
                })
        }
        .onAppear {
            numerator = viewModel.getProgress().0
            denominator = viewModel.getProgress().1
        }
    }
}

