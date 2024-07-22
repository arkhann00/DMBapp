//
//  ChoseHomeImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 07.07.2024.
//

import SwiftUI
import PhotosUI

struct ChoseHomeImageView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    private let userDefaults = UserDefaultsManager.shared
    
    @State var isImagePickerShow = false
    @State var image:Image
    
    @State var photoItem:PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: HomeViewModel) {
        image = viewModel.getBackgroundImage()
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image("BlackArrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                
            }
            .padding()
            Spacer()
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 588)
                .padding()
                .overlay(alignment: .top) {
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 31, height: 30)
                            .foregroundStyle(.black)
                            .padding()
                    }
                    .padding()
                }
                .overlay(alignment: .bottom) {
                    PhotosPicker(selection: $photoItem, matching: .images, preferredItemEncoding: .automatic) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 53)
                            .padding()
                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                            .overlay {
                                Text("ДОБАВИТЬ ФОТО НА ФОН".localize(language: viewModel.getLanguage()))
                                    .font(.custom("benzin-extrabold", size: 15))
                                    .foregroundStyle(.white)
                            }
                        
                    }
                    .onChange(of: photoItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                viewModel.saveBackground(imageData: data)
                                image = viewModel.getBackgroundImage()
                            }
                        }
                        
                    }
                }
                Spacer()
        }
        .background {
            image
                .resizable()
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ChoseHomeImageView(viewModel: HomeViewModel())
}
