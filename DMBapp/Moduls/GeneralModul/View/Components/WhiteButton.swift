//
//  WhiteButton.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.12.2024.
//

import SwiftUI

struct WhiteButton: View {
    
    var text:String
    var complition: () -> ()
    
    var body: some View {
        Button {
            complition()
        } label: {
            Capsule()
                .foregroundStyle(Color.dmbWhite)
                .frame(height: 61)
                .overlay {
                    Text(text)
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .medium))
                }
        }
    }
    
}

#Preview {
    WhiteButton(text: "Tap on me", complition: {
        
    })
}
