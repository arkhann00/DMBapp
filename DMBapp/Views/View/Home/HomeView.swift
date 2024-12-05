//
//  HomeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @State  var isInterfaceHidden = false
    
    @State var isMessageViewPresented = false
    @State var tabbarPath = NavigationPath()
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    
    @State var isSettingsPresented = false
    @State var isCalendarViewPresented = false
    
    @State var language:String = "default"
    @State var isBackgroundDim = false
    
    @State var isImagePickerShow = false
    @State var image:Image = Image("")
    
    @State var isImageSizeBig = false
    
    @State var photoItem:PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if !isInterfaceHidden {
                    withAnimation(.bouncy) {
                        VStack {
                            HStack {
                                
                                NavigationLink {
                                    SettingsView()
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Image("Settings")
                                        .resizable()
                                        .frame(width: 32, height: 26)
                                }
                                
                                Spacer()
                                if viewModel.isAuthorizedUser() {
                                    NavigationLink {
                                        
                                        UserProfileView(viewModel: viewModel)
                                            .navigationBarBackButtonHidden()
                                        
                                        
                                    } label: {
                                        
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 7)
                                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                                .frame(width: 37,height: 24)
                                            
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    
                                    
                                    
                                }
                                else {
                                    NavigationLink {
                                        
                                        RegisterView(viewModel: RegisterViewModel())
                                            .navigationBarBackButtonHidden()
                                        
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 7)
                                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                                .frame(width: 178,height: 28)
                                            Text("ЗАРЕГЕСТРИРОВАТЬСЯ".localize(language: language))
                                                .font(.custom("benzin-extrabold", size: 9))
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.trailing,5)
                                    }
                                    
                                    
                                }
                                
                            }
                            .padding()
                            
                            ProgressLineView(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            HStack {
                                
                                Spacer()
                                
                                VStack {
                                    
                                    NavigationLink {
                                        FriendsView(viewModel: viewModel)
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 43,height: 25)
                                            .foregroundStyle(.white)
                                            .overlay {
                                                Image("friends")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .padding(.trailing,5)
                                                    .overlay(alignment:.topTrailing) {
                                                        Text("+")
                                                            .font(.system(size: 10))
                                                            .padding(.leading)
                                                            .foregroundStyle(.black)
                                                            .bold()
                                                    }
                                                
                                            }
                                            .overlay(alignment: .topTrailing) {
                                                if !viewModel.friendshipInvites.isEmpty {
                                                    Circle()
                                                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                                        .frame(width: 8)
                                                }
                                            }
                                    }
                                    .padding()
                                    
                                    
                                    
                                    
                                    PhotosPicker(selection: $photoItem, matching: .images, preferredItemEncoding: .automatic) {
                                        Image("ImageImage")
                                            .resizable()
                                            .frame(width: 32, height: 26)
                                            .padding(.horizontal)
                                        
                                    }
                                    
                                    .onChange(of: photoItem) { newValue in
                                        Task {
                                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                                Task {
                                                    await viewModel.saveBackground(imageData: data) { image in
                                                        DispatchQueue.main.async {
                                                            self.image = image
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                    .padding(.bottom)
                                    Button {
                                        withAnimation(.default) {
                                            isInterfaceHidden.toggle()
                                        }
                                    } label: {
                                        Image("Eye")
                                            .resizable()
                                            .frame(width: 35, height: 26)
                                    }
                                    
                                    
                                }
                            }
                            
                            Spacer()
                            VStack {
                                ProgressSheetView(viewModel: viewModel, language: language)
                                    .padding(.horizontal)
                                DemobilizationTimeView(viewModel: viewModel, language: language)
                                    .padding(.bottom)
                                    .padding(.horizontal)
                            }
                            
                            
                        }
                        
                    }
                }
                else {
                    withAnimation(.bouncy) {
                        VStack(alignment: .trailing) {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation(.default) {
                                        isInterfaceHidden.toggle()
                                    }
                                } label: {
                                    Image("Eye")
                                        .resizable()
                                        .frame(width: 35, height: 26)
                                }
                            }
                            .padding(.top,65)
                            .padding()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                }
                
                if viewModel.viewState == .loading {
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .opacity(0.5)
                        .overlay {
                            ProgressView()
                        }
                }
                
            }
            
            
        }
        .overlay(content: {
            if isImageSizeBig == true {
                BigSizeImageError(isPresented: $isImageSizeBig)
            }
        })
        
        .onAppear {
            image = viewModel.getBackgroundImage()
            isBackgroundDim = viewModel.getIsDimBackground()
            viewModel.fetchTimer()
        }
        .background {
            image
                .resizable()
                .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                .frame(maxWidth: .infinity)
                .scaledToFill()
                .ignoresSafeArea()
        }
        
    }
    
    
    func calculateImageSize(image: UIImage) -> Bool {
        
        guard let data = image.pngData() else { return false }
        if data.count >= 10000000 {
            return false
        }
        
        return true
    }
    
    
}


#Preview {
    HomeView()
}
