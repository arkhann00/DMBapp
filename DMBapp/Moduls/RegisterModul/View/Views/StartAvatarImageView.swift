//
//  StartAvatarImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 16.12.2024.
//

import SwiftUI
import Combine

struct StartAvatarImageView: View {
    @ObservedObject var viewModel: RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var image:UIImage?
    
    @State var isShowImageView:Bool = false
    
    var body: some View {
        
            VStack {
            
                    Text("Фото профиля")
                        .font(.system(size: 48, weight: .bold))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    Button {
                        isShowImageView = true
                    } label: {
                        
                        Image(uiImage: (image ?? UIImage(named: Images.addAvatar()))!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .scaledToFill()
                            .clipShape(Circle())
                            
                    }
                    
                    
                    Spacer()
                
                
                
                Spacer()
                
                
                Button {
                    path.removeLast(path.count)
                } label: {
                    Capsule()
                        .foregroundStyle(Color.dmbRed)
                        .frame(height: 61)
                        .overlay {
                            Text("Сохранить")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium))
                        }
                }
                
                Button {
                    path.removeLast(path.count)
                } label: {
                    Capsule()
                        .foregroundStyle(Color.dmbWhite)
                        .frame(height: 61)
                        .overlay {
                            Text("Пропустить")
                                .foregroundStyle(.black)
                                .font(.system(size: 18, weight: .medium))
                        }
                }
                .padding(.bottom)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                Color(.white)
                    .ignoresSafeArea()
                    .frame(maxHeight: .infinity)
            }
            .sheet(isPresented: $isShowImageView, content: {
                AvatarImagePicker(image: $image)
            })
        }
    
}

#Preview {
    StartAvatarImageView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
