//
//  UserProfileView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 06.08.2024.
//

import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    
    @Environment(\.dismiss) var dismiss
    
    @State var isStatusViewPresented = false
    @State var isPresentDeleteAccountAlert = false
    @State var isPresentLogOutAlert = false
    @State var isPresentStatusView = false
    
    @State var isPresentAlert = false
    @State var isImageSizeBig = false
    
    @State var profileImage:UIImage?
    @State var currentImage = UIImage(systemName: "person.fill")
    
    @State var isShowImageView = false
    
    init(viewModel:HomeViewModel) {
        self.viewModel = viewModel
        self.currentImage = viewModel.getAvatarImage()
    }
    
    var body: some View {
        ZStack {
                if let user = viewModel.user {
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
                                if let image = currentImage {
                                    Image(uiImage: viewModel.getAvatarImage())
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .foregroundStyle(.black)
                                        .frame(width: 94, height: 94)
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                isPresentAlert = true
                                            } label: {
                                                
                                                
                                                Circle()
                                                    .foregroundStyle(.white)
                                                    .frame(width: 35, height: 35)
                                                    .overlay {
                                                        Image("pencil")
                                                            .resizable()
                                                            .frame(width: 18, height: 18)
                                                    }
                                                
                                                
                                            }
                                        }
                                        .confirmationDialog("Изменение аватарки", isPresented: $isPresentAlert, titleVisibility: .automatic,actions: {
                                            Button {
                                                isShowImageView = true
                                            } label: {
                                                Text("Изменить аватарку")
                                            }
                                            Button {
                                                Task {
                                                    await viewModel.removeAvatarImage()
                                                }
                                                currentImage = UIImage(systemName: "person.fill")
                                            } label: {
                                                Text("Сбросить аватарку")
                                                    .foregroundStyle(.red)
                                            }
                                            
                                        })
                                        .sheet(isPresented: $isShowImageView, content: {
                                            AvatarImagePicker(image: $profileImage)
                                        })
                                        .onChange(of: profileImage) { image in
                                            if let image = image {
                                                if calculateImageSize(image: image) {
                                                    viewModel.updateAvatarImage(image: image)
                                                    self.currentImage = image
                                                } else {
                                                    isImageSizeBig = true
                                                }
                                            }
                                        }
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(user.nickname)
                                        .font(.custom("benzin-regular", size: 12))
                                        .scaledToFit()
                                        .padding(.horizontal)
                                        .background(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(Color(red:242/255, green: 242/255, blue: 242/255))
                                            
                                                .frame(width: 177, height: 22)
                                        }
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
                                
                                
                                
                                Button {
                                    Task {
                                       await viewModel.logOut()
                                    }
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
                                        Task {
                                            await viewModel.deleteAccount()
                                        }
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
                        
                        if viewModel.viewState == .loading {
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .ignoresSafeArea()
                                .opacity(0.5)
                                .overlay {
                                    ProgressView()
                                }
                        }
                    }
                    .foregroundStyle(.black)
                
                
            } else {
                VStack {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchUser()
                        }
                    Button {
                        Task {
                            await viewModel.logOut()
                        }
                        isPresentStatusView = true
                    } label: {
                        Text("Выйти из аккаунта".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.gray)
                            .font(.custom("benzin-regular", size: 12))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color(.white)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            
        }
        .onAppear(perform: {
            currentImage = viewModel.getAvatarImage()
        })
        .overlay(content: {
            if isImageSizeBig == true {
                BigSizeImageError(isPresented: $isImageSizeBig)
            }
        })
        .background(content: {
            Color(.white)
                .ignoresSafeArea()
        })
        .navigationDestination(isPresented: $isPresentStatusView) {
            RegisterView(viewModel: RegisterViewModel())
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            
        }
    }
    func calculateImageSize(image: UIImage) -> Bool {
        
        guard let data = image.pngData() else { return false }
        if data.count >= 10000000 {
            return false
        }
        
        return true
    }
}
