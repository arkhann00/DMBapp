//
//  CustomProgressCiew.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.12.2024.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            
    }
}

#Preview {
    CustomProgressView()
        .background {
            Image("DefaultBackground")
        }
}
