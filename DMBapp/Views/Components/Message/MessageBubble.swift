//
//  ChatBubble.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.11.2024.
//

import SwiftUI

struct MessageBubble: Shape {
    
    let isSender: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    isSender ? .bottomLeft : .bottomRight
                                ],
                                cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
    
}

#Preview(body: {
    MessageBubble(isSender: true)
})
