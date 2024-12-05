//
//  CustomImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.08.2024.
//

import SwiftUI


struct CustomImageView: View {
    let imageString: String?
    let defaultImage: Image
    
    @State private var loadedImage: UIImage? = nil

    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
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
    }
    
    private func loadImage() {
        guard let imageString = imageString, let imageUrl = URL(string: imageString) else {
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
    CustomImageView(imageString: "", defaultImage: Image(systemName: ""))
}
