//
//  View.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 16.12.2024.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func asUIImage(size: CGSize) -> UIImage {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            // Устанавливаем размеры
            view?.bounds = CGRect(origin: .zero, size: size)
            view?.backgroundColor = .clear

            // Рендерим в `UIImage`
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }
        }
}
