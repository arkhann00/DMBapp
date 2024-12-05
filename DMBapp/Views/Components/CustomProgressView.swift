//
//  CustomProgressView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.11.2024.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.black).opacity(0.4), ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    CustomProgressView()
}
