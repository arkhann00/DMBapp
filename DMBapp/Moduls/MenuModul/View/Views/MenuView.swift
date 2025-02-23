//
//  MenuView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.12.2024.
//

import SwiftUI
import PhotosUI

struct MenuView: View {
    
    @ObservedObject var viewModel:MenuViewModel
    
    @Binding var path:NavigationPath
    
    @State var photoItem:PhotosPickerItem?
    
    @State var isAuthorizedUser:Bool = false
    
    var body: some View {
            VStack(alignment: .leading) {
                
                Text("Меню")
                    .font(.system(size: 48, weight: .bold))
                    .frame(alignment: .leading)
                    .foregroundStyle(.black)
                if isAuthorizedUser {
                    UserBar(viewModel: viewModel, path: $path)
                        .padding(.bottom)
                }
                
                VStack(alignment: .leading,spacing:6) {
                    
//                    Button {
//                        
//                    } label: {
//                        HStack {
//                            Image(Images.friendsIcon())
//                                .resizable()
//                                .frame(width: 27, height: 17)
//                            Text("Друзья")
//                                .foregroundStyle(.black)
//                                .font(.manrope(size: 28, weight: .semibold))
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    
//                    Rectangle()
//                        .frame(height: 1)
//                        .foregroundStyle(Color.dmbWhite)
                    Button {
                        path.append(MenuCoordinatorEnum.calendar)
                    } label: {
                        HStack {
                            Image(Images.calendarIcon())
                                .resizable()
                                .frame(width: 22, height: 25)
                            Text("Календарь")
                                .foregroundStyle(.black)
                                .font(.manrope(size: 28, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.dmbWhite)
                    
                    Button {
                        path.append(MenuCoordinatorEnum.settings)
                    } label: {
                        HStack {
                            Image(Images.settingsIcon())
                                .resizable()
                                .frame(width: 23, height: 23)
                            Text("Настройки")
                                .foregroundStyle(.black)
                                .font(.manrope(size: 28, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.dmbWhite)
                    
                    PhotosPicker(selection: $photoItem, matching: .images, preferredItemEncoding: .automatic) {
                        HStack {
                            Image(Images.changeBackgroundIcon())
                                .resizable()
                                .frame(width: 23, height: 23)
                            Text("Поменять фон")
                                .foregroundStyle(.black)
                                .font(.manrope(size: 28, weight: .semibold))
                            if viewModel.viewState == .loadingUpdateBackgroundImage {
                                ProgressView()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .onChange(of: photoItem ?? PhotosPickerItem(itemIdentifier: "")) { newValue in
                            Task {
                                if let data = try? await newValue.loadTransferable(type: Data.self) {
                                    Task {
                                        await viewModel.saveBackground(imageData: data)
                                    }
                                    
                                    
                                }
                            }                        
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.dmbWhite)
                    
                }
                .padding(.vertical, 1)
                .frame(maxWidth: .infinity)
                
                if !isAuthorizedUser {
                    Button {
                        path.append(MenuCoordinatorEnum.signUp)
                    } label: {
                        RoundedRectangle(cornerRadius: 31)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.dmbRed)
                            .frame(height: 61)
                            .overlay {
                                Text("Зарегистрироваться")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .medium))
                            }
                            .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(content: {
                Color.white
                    .ignoresSafeArea()
            })
            .onAppear {
                isAuthorizedUser = viewModel.isAuthorizedUser()
            }
            .overlay {
                if viewModel.viewState == .loading {
                    CustomProgressView()
                }
            }
            .colorScheme(.light)
            
        
    }
}

#Preview {
    MenuView(viewModel: MenuViewModel(), path: .constant(NavigationPath()))
}
