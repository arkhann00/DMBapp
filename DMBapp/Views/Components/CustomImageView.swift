//
//  CustomImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.08.2024.
//

import SwiftUI


struct CustomImageView: View {
    
    let imageString:String?
    let defaultImage:Image
    
    init(imageString:String?, defaultImage:Image) {
        self.imageString = imageString
        self.defaultImage = defaultImage
    }
    
    var body: some View {
        if let imageString = self.imageString,
           let imageUrl = URL(string: imageString),
            let imageData = try? Data(contentsOf: imageUrl),
            let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            defaultImage
                .resizable()
                
        }
        
    }
    

    
}

    


#Preview {
    CustomImageView(imageString: "", defaultImage: Image(systemName: ""))
}
