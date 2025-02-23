//
//  StripedAnimationProgressLine.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 02.01.2025.
//

import SwiftUI

struct StripedAnimationProgressLine: View {
    
    var width:CGFloat
    
    @State var moveProgress:CGFloat = 0
    let stripeWidth:CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    
                HStack(spacing: 2) {
                    ForEach(0 ..< Int(geometry.size.width / stripeWidth), id: \.self) { i in
                        Capsule()
                            .frame(width: stripeWidth)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                            .offset(x: moveProgress + CGFloat(i) * stripeWidth)
                    }
                }
                .offset(x: -geometry.size.width)
                .animation(
                    Animation.linear(duration: 20)
                        .repeatForever(autoreverses: false), value: moveProgress
                )
                .onAppear {
                    self.moveProgress = geometry.size.width
                }
                .frame(width: width, height: 8)
            }
            .frame(width: width, height: 8)
            
        }
        .frame(width: width, height: 8)
    }
}

#Preview {
    StripedAnimationProgressLine(width: UIScreen.main.bounds.width)
}
