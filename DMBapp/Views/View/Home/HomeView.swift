//
//  HomeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @State var viewState:ViewState
    @ObservedObject var viewModel:HomeViewModel
    
    @State  var isInterfaceHidden = false
    
    @State var isMessageViewPresented = false
    @State var tabbarPath = NavigationPath()
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    
    @State var isSettingsPresented = false
    @State var isCalendarViewPresented = false
    
    @State var language:String = "default"
    @State var isBackgroundDim = false
    
    @State var isImagePickerShow = false
    @State var image:Image?
    
    @State var photoItem:PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    
    init(viewState:ViewState) {
        self.viewState = viewState
        self.viewModel = HomeViewModel(viewState: viewState)
        
        language = viewModel.getLanguage()
        isBackgroundDim = viewModel.getIsDimBackground()
        image = viewModel.getBackgroundImage()
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
                                
                                NavigationLink {
                                    if let user = viewModel.user {
                                        UserProfileView(viewModel: viewModel, user: user)
                                            .navigationBarBackButtonHidden()
                                    }
                                    else {
                                        RegisterView(viewModel: RegisterViewModel())
                                            .navigationBarBackButtonHidden()
                                    }
                                } label: {
                                    
                                    if viewModel.user != nil || viewState == .online {
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
                                    else {
                                        if viewState == .offline {
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
                            }
                            .padding()
                            
                            ProgressLineView(numerator: viewModel.getProgress().0, denominator: viewModel.getProgress().1)
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
                                    .padding(.top)
                                    
                                    
                                    
                                    PhotosPicker(selection: $photoItem, matching: .images, preferredItemEncoding: .automatic) {
                                        Image("ImageImage")
                                            .resizable()
                                            .frame(width: 32, height: 26)
                                            .padding(.horizontal)
                                            .padding(.top)
                                    }
                                    
                                    .onChange(of: photoItem) { newValue in
                                        Task {
                                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                                viewModel.saveBackground(imageData: data)
                                                image = viewModel.getBackgroundImage()
                                            }
                                        }
                                        
                                    }
                                    .padding(.bottom,4)
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
                                ProgressSheetView(viewModel: viewModel, language: language, passedTime: viewModel.getPassedTime(), leftTime: viewModel.getLeftTime())
                                    .padding(.horizontal)
                                DemobilizationTimeView(viewModel: viewModel, timeBeforeDemobilization: viewModel.getRemainingDays(), language: language)
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
            }
            .background {
                (image ?? viewModel.getBackgroundImage())
                    .resizable()
                    .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                    .frame(maxWidth: .infinity)
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            
        }
        .onAppear {
            updateSettings()
        }
    }
    
    func updateSettings() {
        language = viewModel.getLanguage()
        isBackgroundDim = viewModel.getIsDimBackground()
    }
    
}


#Preview {
    HomeView(viewState: .offline)
}
