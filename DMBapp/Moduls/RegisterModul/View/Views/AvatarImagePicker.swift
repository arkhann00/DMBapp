//
//  AvatarImagePicker.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 16.12.2024.
//

import Foundation
import SwiftUI

struct AvatarImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    private let networkManager:MenuNetworkManagerProtocol = NetworkManager()
    private let userDefaults = UserDefaultsManager.shared
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: AvatarImagePicker
        
        init(parent: AvatarImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectImage = info[.editedImage] as? UIImage {
                self.parent.image = selectImage
                self.parent.networkManager.updateAvatarImage(image: selectImage) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.parent.userDefaults.set(selectImage.pngData(), forKey: .userAvatarImage)
                        print("SUCCESS UPLOAD IMAGE")
                    case .failure(let error):
                        print("FAILURE UPLOAD IMAGE: \(error.localizedDescription)")
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        
    }
    
}
