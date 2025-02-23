//
//  RedButton.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.12.2024.
//

import SwiftUI

struct RedButton: View {
    
    var text:String
    var complition: () -> ()
    
    var body: some View {
        Button {
            complition()
        } label: {
            Capsule()
                .foregroundStyle(Color.dmbRed)
                .frame(height: 61)
                .overlay {
                    Text(text)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
        }
    }
}

#Preview {
    RedButton(text: "Tap on me") {
        print("Tap")
    }
}
