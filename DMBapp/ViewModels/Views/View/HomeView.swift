//
//  HomeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    @State  var isInterfaceHidden = false
    
    @State var isMessageViewPresented = false
    @State var tabbarPath = NavigationPath()
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    
    @State var isSettingsPresented = false
    @State var isCalendarViewPresented = false
    
    @State var language:String = "default"
    @State var isBackgroundDim = false
        
    @Environment(\.dismiss) var dismiss
    
    init() {
        language = viewModel.getLanguage()
        isBackgroundDim = viewModel.getIsDimBackground()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.getBackgroundImage()
                    .resizable()
                
                    .overlay(isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
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
                                
                                Button {
                                    viewModel.deleteStorageData()
                                } label: {
                                    
                                    if (viewModel.isUserOnline()){
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
                            
                            ProgressLineView(numerator: viewModel.getProgress().0, denominator: viewModel.getProgress().1)
                                .padding(.horizontal)
                            
                            HStack {
                                
                                Spacer()
                                VStack {
                                    NavigationLink {
                                        ChoseHomeImageView(viewModel: viewModel)
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        Image("ImageImage")
                                            .resizable()
                                            .frame(width: 32, height: 26)
                                            .padding(.horizontal)
                                            .padding(.top)
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
                                    .opacity(0.44)
                                    
                                    
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
                                .opacity(0.44)
                            }
                            .padding()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                }
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
    HomeView()
}
