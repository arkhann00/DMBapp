//
//  CustomNetworkImage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 18.12.2024.
//

import SwiftUI

struct CustomNetworkImage: View {
    
    @ObservedObject var viewModel:ChatsViewModel
    var avatarLink:String?
    var defaultImage:Image
    
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        if let loadedImage = loadedImage {
            Image(uiImage: loadedImage)
                .resizable()
                .onAppear {
                    viewModel.countOfImages+=1
                }
        } else {
            defaultImage
                .resizable()
                .background(Color.white)
                .clipShape(Circle())
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let avatarLink = avatarLink, let imageUrl = URL(string: avatarLink) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = uiImage
                    
                }
            } else if let error = error {
                print("Error loading image: \(error)")
            }
        }.resume()
    }
    
}

#Preview {
    CustomNetworkImage(viewModel: ChatsViewModel(), avatarLink: "", defaultImage: Image("person.fill"))
}
