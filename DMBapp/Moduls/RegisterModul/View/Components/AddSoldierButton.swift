//
//  AddSoldierButton.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import SwiftUI

struct AddSoldierButton: View {
    
   
    
    @Binding var isActive:Bool
    var completion: () -> ()
    
    var body: some View {
        Button {
            isActive = false
            completion()
        } label: {
            RoundedRectangle(cornerRadius: 31)
                .foregroundStyle(isActive ? .dmbRed : Color.dmbWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 61)
                .overlay {
                    Text("Добавить")
                        .foregroundStyle(isActive ? .white : .dmbBlack)
                        .bold()
                }
        }
        .disabled(!isActive)
    }
}

#Preview {
    AddSoldierButton(isActive: .constant(false),completion: {})
}
