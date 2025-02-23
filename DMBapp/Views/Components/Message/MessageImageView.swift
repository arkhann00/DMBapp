//
//  MessageImageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 16.09.2024.
//

import SwiftUI

struct MessageImageView: View {
    
    @ObservedObject var viewModel:ViewModel
    
    init(imageUrl:String) {
        
        viewModel = ViewModel(imageUrl: imageUrl)
        viewModel.fetchImage()
        
    }
    
    var body: some View {
        ZStack {
            if viewModel.viewState == .loading {
                ProgressView()
                    .padding(.trailing)
            } else if viewModel.viewState == .offline {
                Image(systemName: "photo")
                    .resizable()
                    .foregroundStyle(.black)
            } else if let imageData = viewModel.imageData, viewModel.viewState == .online {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    func updateImage() {
        viewModel.fetchImage()
    }
    
    
    class ViewModel:ObservableObject {
        
        @Published var viewState:ViewState = .loading
        @Published var imageUrl:String
        @Published var imageData:Data?
        
        private let networkManager = NetworkManager.shared
        init(viewState: ViewState = .loading, imageUrl: String, imageData: Data? = nil) {
            self.viewState = viewState
            self.imageUrl = imageUrl
            self.imageData = imageData
        }
        
        func fetchImage() {
            
            viewState = .loading
            
            
            networkManager.loadImage(imageURL: imageUrl, completion: {[weak self] result in
                switch result {
                case .success(let imageData):
                    print("SUCCESS LOAD IMAGE")
                    self?.imageData = imageData
                    self?.viewState = .online
                case .failure(let error):
                    self?.viewState = .offline
                    print("ERROR LOAD IMAGE")
                }
            })
            
            
        }
    }
}

#Preview {
    MessageImageView(imageUrl: "")
}
