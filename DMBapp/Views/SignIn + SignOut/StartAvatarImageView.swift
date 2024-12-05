//
//  StartAvatarImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 27.09.2024.
//

import SwiftUI
import Combine

struct StartAvatarImageView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    @State var image:UIImage?
    
    @State var isShowImageView:Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    Spacer()
                    NavigationLink {
                        DateView(viewModel: viewModel)
                    } label: {
                        Text("Далее")
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 12))
                    }
                }
                
                
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    
                    Text("Можете добавить аватарку")
                        .foregroundStyle(.black)
                        .font(.custom("benzin-regular", size: 17))
                        .padding()
                    
                    Button {
                        isShowImageView = true
                    } label: {
                        
                        Image(uiImage: (image ?? UIImage(named: "whitePerson"))!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .scaledToFill()
                            .clipShape(Circle())
                            .background {
                                if image == nil {
                                    Circle()
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    
                    
                    
                }
                .sheet(isPresented: $isShowImageView, content: {
                    AvatarImagePicker(image: $image)
                })
                
                Spacer()
                
            }
            .background {
                Color(.white)
                    .ignoresSafeArea()
                    .frame(maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    StartAvatarImageView(viewModel: RegisterViewModel())
}
