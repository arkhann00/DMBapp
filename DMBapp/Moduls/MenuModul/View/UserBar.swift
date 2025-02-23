//
//  UserBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.12.2024.
//

import SwiftUI

struct UserBar: View {
        
    @State var user:LocalUser?
    
    @ObservedObject var viewModel:MenuViewModel
    @Binding var path:NavigationPath
    
   
    var body: some View {
        
        HStack {
            if let user = user {
                
                if let image = user.avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.black)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.black)
                }
                VStack(alignment: .leading) {
                    Text("@\(user.nickname)")
                        .foregroundStyle(.black)
                        .font(.system(size: 16))
                    
                    Button {
                        path.append(MenuCoordinatorEnum.profile)
                    } label: {
                        
                        Text("Настройки профиля")
                            .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                        Image("rightArrow")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.dmbWhite)
                
        }
        .onAppear {
            user = viewModel.getUser()
        }
        
    }
}

#Preview {
    UserBar(viewModel: MenuViewModel(), path: .constant(NavigationPath()))
}
