//
//  NewPasswordView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.01.2025.
//

import SwiftUI

struct NewPasswordView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var newPassword = ""
    
    var body: some View {
        
        VStack {
            VStack (alignment: .leading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 20, height: 19)
                    Text("Назад")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                }
                
                Text("Введите новый пароль")
                    .font(.system(size: 48, weight: .bold))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .foregroundStyle(.black)
                    .padding(.bottom, -8)
            }
            
            VStack {
                CustomPasswordTextField(placeholder: "Новый пароль", text: $newPassword)
                
                RedButton(text: "Подтвердить") {
                    Task {
                        await viewModel.resetPassword(password: newPassword)
                    }
                }
            }
            .padding(.vertical)
            

            Spacer()
        }
        .padding()
        .background {
            Color.white.ignoresSafeArea()
        }
        .onChange(of: viewModel.viewState) { state in
            switch state {
            case .successPasswordReset:
                path.removeLast(path.count)
            default:
                break
            }
        }
        
    }
}

#Preview {
    NewPasswordView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
