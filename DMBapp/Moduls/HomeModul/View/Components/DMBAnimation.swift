//
//  DMBAnimation.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 27.01.2025.
//

import SwiftUI

struct DMBAnimation: View {
    @State private var selectedTab = 0
    
    var cornerRadius:CGFloat = 40
    
    @State var progress:CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
            //            .trim(from: startPoint, to: endPoint)
                .stroke(lineWidth: 2)
            
                .shadow(color: Color(red: 200/255, green: 211/255, blue: 109/255),radius: 5)
                .foregroundStyle(.white.opacity(0.2))
            RoundedRectangle(cornerRadius: cornerRadius)
                .trim(from: max(0, progress), to: min(1, progress + 0.2))
                .stroke(lineWidth: 2)
                .animation(.linear(duration: 3).repeatForever(autoreverses: false))
                .onAppear {
                    withAnimation {
                        progress = 1
                    }
                }
                .foregroundStyle(Color(red: 200/255, green: 211/255, blue: 109/255))
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .trim(from: progress - 1, to: progress - 0.8)
                .stroke(lineWidth: 2)
                .opacity(progress > 0.8 ? 1 : 0)
                .animation(.linear(duration: 3).repeatForever(autoreverses: false))
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        progress = 1.0
                    }
                }
                .foregroundStyle(Color(red: 200/255, green: 211/255, blue: 109/255))
            
            
            
        }
                    
            
            
        
    }
}

#Preview {
    DMBAnimation()
        .background {
        Color.black
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
        .padding()
        .padding()
        .padding()
        .padding()
}
