//
//  ResponseData.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 24.09.2024.
//

import Alamofire
import SwiftUI
import Foundation

extension DataResponse {
    func printJsonError() {
        if let data = self.data {
            do {
                let networkError = try JSONDecoder().decode(NetworkError.self, from: data)
                print(networkError.message)
            } catch {
                print(self)
            }
        }
    }
}
