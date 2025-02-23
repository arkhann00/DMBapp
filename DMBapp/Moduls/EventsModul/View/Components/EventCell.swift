//
//  EventCell.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 30.12.2024.
//

import SwiftUI

struct EventCell: View {
    
    var event: Event
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Image(Images.redStar())
                    .resizable()
                    .frame(width: 12, height: 12)
                Text("Событие")
                    .font(.manrope(size: 12, weight: .regular))
                    .foregroundStyle(Color.dmbBlack.opacity(0.5))
                
            }
            if let text = event.text, let date = event.date {
                Text("\(text)")
                    .font(.manrope(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                
                Text("\(date.getFullDateAsString())")
                    .font(.manrope(size: 12, weight: .medium))
                    .foregroundStyle(Color.dmbGray)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.dmbWhite)
        }
    }
}
