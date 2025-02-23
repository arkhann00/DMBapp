//
//  UIImage.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 30.10.2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension UIImage: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .image) { image in
            guard let data = image.pngData() else {
                throw NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to PNG"])
            }
            return data
        }
    }
}
