//
//  CustomPasswordTextField.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 18.12.2024.
//

import SwiftUI

struct CustomPasswordTextField: View {
    @State var placeholder:String
    @Binding var text:String
    
    var isError = false
    
    var body: some View {
        
        SecureField("", text: $text)
            .autocorrectionDisabled()
            .foregroundStyle(.black)
            .background(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(Color.dmbBlack)
                }
            }
            .padding()
            .overlay(content: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(text.isEmpty || isError ? Color.dmbRed : Color.dmbBlack)
            })
            .background {
                Color.white.ignoresSafeArea()
            }
        
        
        
    }
}

#Preview {
    CustomPasswordTextField(placeholder: "", text: .constant(""))
}
