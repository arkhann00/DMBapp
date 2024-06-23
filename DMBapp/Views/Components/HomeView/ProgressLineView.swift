//
//  ProgressView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 25.05.2024.
//

import SwiftUI

struct ProgressLineView: View {
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()
    
    @State var numerator:Double
    @State var denominator:Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                .frame(width: 352*(numerator/denominator), height: 30)
            
            TextField("", text: .constant("\((numerator/denominator*100))%"))
                .multilineTextAlignment(.center)
                .font(.custom("benzin-extrabold", size: 12))
                .frame(width: 352)
                .disabled(true)
                .foregroundStyle(.black)
                .onReceive(timer, perform: { _ in
                    if (numerator <= denominator) {
                        numerator+=1
                    }
                })
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProgressLineView(numerator: 20, denominator: 100)
}
