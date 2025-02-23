//
//  UserProfileView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.08.2024.
//

import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    @State var user:User
    
    @Environment (\.dismiss) var dismiss
    
    @State var isStatusViewPresented = false
    @State var isPresentDeleteAccountAlert = false
    @State var isPresentLogOutAlert = false
    @State var isPresentStatusView = false
    
    @State var profileImage:UIImage?
    @State var currentImage = UIImage(named: "person.fill")
    
    @State var isShowImageView = false
    
    init(viewModel:HomeViewModel, user:User) {
        self.viewModel = viewModel
        self.user = user
    }
    
    var body: some View {
        ZStack {
            if viewModel.requestResult == .loading {
                CustomActivityIndicator()
            }
            else {
                VStack {
                    HStack {
                        
                        Button { dismiss() } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23, height: 22)
                        }
                        .padding(.horizontal)
                        .rotationEffect(.degrees(180))
                        
                        Spacer()
                        
                    }
                    VStack {
                        Text("РЕДАКТИРОВАНИЕ ПРОФИЛЯ".localize(language: viewModel.getLanguage()))
                            .font(.custom("benzin-extrabold", size: 14.5))
                            .padding(.top)
                        
                        Rectangle()
                            .foregroundStyle(.black)
                            .frame(height: 1)
                            .padding()
                        
                        HStack {
                            Button {
                                isShowImageView = true
                            } label: {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 94, height: 93)
                                        .overlay(alignment: .trailing) {
                                            VStack {
                                                Circle()
                                                    .frame(width: 35, height: 35)
                                                    .overlay {
                                                        Image("pencil")
                                                            .resizable()
                                                            .frame(width: 18, height: 18)
                                                        
                                                    }
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                            
                                        }
                                } else {
                                    ZStack {
                                        if let imageUrl = viewModel.user?.avatarLink {
                                            CustomImageView(imageUrl: imageUrl)
                                                .frame(width: 94, height: 94)
                                        } else {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 94, height: 94)
                                                .foregroundStyle(.black)
                                        }
                                    }
                                        .overlay(alignment: .trailing) {
                                            VStack {
                                                Circle()
                                                    .frame(width: 35, height: 35)
                                                    .overlay {
                                                        Image("pencil")
                                                            .resizable()
                                                            .frame(width: 18, height: 18)
                                                        
                                                    }
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                            
                                        }
                                }
                            }
                            .sheet(isPresented: $isShowImageView, content: {
                                AvatarImagePicker(image: $profileImage)
                                    .onDisappear(perform: {
                                        currentImage = profileImage
                                    })
                            })
                            
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.custom("benzin-regular", size: 12))
                                    .scaledToFit()
                                    .padding(.horizontal)
                                    .background(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                                        
                                            .frame(width: 177, height: 22)
                                    }
                                Text("@" + (user.nickname))
                                    .font(.custom("Montserrat", size: 10))
                                    .foregroundStyle(Color(red: 130/255, green: 93/255, blue: 93/255))
                                    .padding(.vertical, 7)
                                    .padding(.horizontal)
                                
                                
                            }
                            .padding()
                            Spacer()
                            
                        }
                        .padding()
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.custom("benzin-extrabold", size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.black)
                            TextField("",text: .constant(user.login))
                                .disabled(true)
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                                }
                                .padding(.bottom)
                            Text("Пароль".localize(language: viewModel.getLanguage()))
                                .font(.custom("benzin-extrabold", size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.black)
                            SecureField("", text: .constant("0000000"))
                                .disabled(true)
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                                }
                            
                            
                            Button {
                                viewModel.logOut()
                                isPresentStatusView = true
                            } label: {
                                Image("door")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                Text("Выйти из аккаунта".localize(language: viewModel.getLanguage()))
                                    .foregroundStyle(.black)
                                    .font(.custom("benzin-regular", size: 12))
                            }
                            
                            .padding(.vertical)
                            
                            Button {
                                isPresentDeleteAccountAlert = true
                            } label: {
                                Image("trash")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                Text("Удалить аккаунт".localize(language: viewModel.getLanguage()))
                                    .foregroundStyle(Color(red:180/255,green: 0, blue: 0))
                                    .font(.custom("benzin-regular", size: 12))
                            }
                            .alert("Вы точно хотите удалить аккаунт?".localize(language: viewModel.getLanguage()), isPresented: $isPresentDeleteAccountAlert) {
                                Button(role: .cancel) {
                                    viewModel.deleteAccount()
                                    isPresentStatusView = true
                                } label: {
                                    Text("Удалить".localize(language: viewModel.getLanguage()))
                                }
                                
                                Button(role: .destructive) {} label: {
                                    Text("Отмена".localize(language: viewModel.getLanguage()))
                                }
                                
                                
                            } message: {
                                Text("При удалении аккаунта, не будет возможности восстановить данные".localize(language: viewModel.getLanguage()))
                            }
                            
                            
                            
                            
                            
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                }
                .foregroundStyle(.black)
                
                
                
            }
            
        }
        .background(content: {
            Color(.white)
                .ignoresSafeArea()
        })
        .navigationDestination(isPresented: $isPresentStatusView) {
            StatusView()
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            
        }
    }
}
    
        



#Preview {
    UserProfileView(viewModel: HomeViewModel(), user: User(id: 0, login: "aaaa@gmail.com", name: "Kirill Ivanov", nickname: "Kirll", avatarLink: nil, userType: ""))
}
