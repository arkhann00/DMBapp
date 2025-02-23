//
//  ProfileView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 17.12.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State var user:LocalUser?
    
    @ObservedObject var viewModel:MenuViewModel
    @Binding var path:NavigationPath
    
    @State var isPresentStartView = false
    
    @State var isPresentAvatarImage = false
    
    @State var profileImage:UIImage?
    
    @Environment(\.dismiss) var dismiss
   
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = user {
                
                
                
                Button {
                    path.removeLast()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 20, height: 19)
                    Text("Меню")
                        .foregroundStyle(Color.dmbGray)
                }
                
                Text("Редактирование профиля")
                    .font(.system(size: 36, weight: .bold))
                    .frame(alignment: .leading)
                    .foregroundStyle(.black)
                
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .foregroundStyle(.black)
                        .frame(width: 80, height: 80)
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                isPresentAvatarImage = true
                            } label: {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.white)
                                    .overlay {
                                        Image(Images.pencil())
                                    }
                            }
                        }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .clipShape(Circle())
                        .foregroundStyle(.black)
                        .frame(width: 80, height: 80)
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                isPresentAvatarImage = true
                            } label: {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.white)
                                    .overlay {
                                        Image(Images.pencil())
                                    }
                            }
                        }
                }
                TextField("", text: .constant("@\(user.nickname)"))
                    .padding()
                    .foregroundStyle(Color.dmbBlack)
                    .disabled(true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16, weight: .medium))
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.dmbWhite)
                    }
                
                TextField("", text: .constant(user.mail))
                    .padding()
                    .foregroundStyle(.black)
                    .disabled(true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16, weight: .medium))
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.dmbWhite)
                    }
                
                Spacer()
                
                VStack {
                    
                    RedButton(text: "Сохранить") {
                        if let image = profileImage {
                            Task {
                                await viewModel.saveAvatarImage(image: image)
                            }
                        }
                    }
                    
                    WhiteButton(text: "Удалить аккаунт") {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    }
                    
                    WhiteButton(text: "Выйти из аккаунта") {
                        Task {
                            await viewModel.logOut()
                        }
                    }
                    
                }
                .padding(.bottom)
                .padding(.bottom)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            Color.white.ignoresSafeArea()
        }
        .blur(radius: viewModel.viewState == .loading ? 2 : 0)
        .overlay {
            if viewModel.viewState == .loading {
                CustomProgressView()
            }
        }
        .onChange(of: viewModel.viewState) { state in
            
            switch state {
                
            case .successLogOut, .successDeleteAccount:
                path.removeLast(path.count)
                
            case .successSaveAvatarImage:
                user = viewModel.getUser()
                
            default:
                break
            }
            
        }
        .sheet(isPresented: $isPresentAvatarImage) {
            AvatarImagePicker(image: $profileImage)
        }
        .onChange(of: profileImage) { image in
            
            self.user = viewModel.getUser()
            profileImage = user?.avatarImage ?? UIImage(systemName: "person.fill")
        }
        .onAppear {
            self.user = viewModel.getUser()
        }
        
    }
}

#Preview {
    ProfileView(viewModel: MenuViewModel(), path: .constant(NavigationPath()))
}
