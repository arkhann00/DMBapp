//
//  CustomDimActivityIndicator.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.09.2024.
//

import SwiftUI

struct CustomDimActivityIndicator: View {
    var body: some View {
        ProgressView {
//            Text("Загрузка...")
//                .font(.custom("benzin-extrabold", size: 17))
        }
        .background {
            Color(.black)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity)
                .opacity(0.5)
        }
    }
}

#Preview {
    CustomDimActivityIndicator()
}
