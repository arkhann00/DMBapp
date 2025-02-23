//
//  CustomActivityIndicator.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 01.08.2024.
//

import SwiftUI

struct CustomActivityIndicator: View {
    
    @State var isAnimating = true
    
    var body: some View {

        ProgressView {
            Text("Загрузка...")
                .font(.custom("benzin-extrabold", size: 17))
        }
        
            
    }
}

#Preview {
    CustomActivityIndicator()
}
