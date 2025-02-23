//
//  MessageBubble.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.12.2024.
//

import SwiftUI

struct MessageBubble: Shape {
    
    let isSender: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let largeRadius: CGFloat = 20  // Радиус для 3-х углов
                let smallRadius: CGFloat = 4  // Радиус для одного угла

        let topLeftRadius = largeRadius
                let topRightRadius = largeRadius
                let bottomLeftRadius = isSender ? largeRadius : smallRadius
                let bottomRightRadius = isSender ? smallRadius : largeRadius

                path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
                
                // Верхняя линия
                path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
                path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + topRightRadius),
                                  controlPoint: CGPoint(x: rect.maxX, y: rect.minY))

                // Правая линия
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
                path.addQuadCurve(to: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY),
                                  controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))

                // Нижняя линия
                path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
                path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeftRadius),
                                  controlPoint: CGPoint(x: rect.minX, y: rect.maxY))

                // Левая линия
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
                path.addQuadCurve(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY),
                                  controlPoint: CGPoint(x: rect.minX, y: rect.minY))

        return Path(path.cgPath)
    }
}

#Preview {
    MessageBubble(isSender: true)
        .padding()
        .padding()
}
