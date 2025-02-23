//
//  MenuNetworkManager.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire
import UIKit

extension NetworkManager: MenuNetworkManagerProtocol {
    
    func updateAvatarImage(image: UIImage, completion: @escaping (Result<Data?, Alamofire.AFError>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Ошибка конвертации изображения")
            return
        }
        
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url.createURL(urlComp: "/user/avatar"), method: .post, headers: getHeaders(token: keychain.load(key: .accessToken) ?? "")).response { response in
            completion(response.result)
        }
    }
    
}
