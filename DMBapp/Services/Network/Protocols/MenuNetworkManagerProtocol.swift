//
//  MenuNetworkManagerProtocol.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 05.02.2025.
//

import Foundation
import Alamofire
import UIKit

protocol MenuNetworkManagerProtocol {
    func updateAvatarImage(image:UIImage, completion:@escaping(Result<Data?,AFError>) -> ())
}
