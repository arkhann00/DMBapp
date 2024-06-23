//
//  HomeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel = HomeViewModel()
    @ObservedObject var settingsRefresh = SettingsViewModel()
    
    @State var isMessageViewPresented = false
    @State var tabbarPath = NavigationPath()
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    
    @State var isSettingsPresented = false
    @State var isCalendarViewPresented = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("MainBackground")
                    .resizable()
                    
                    .overlay(viewModel.isBackgroundDim ? Color.black.opacity(0.6) : Color.black.opacity(0))
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                    
                    
                VStack {
                    HStack {
                        
                        
                        
                        Spacer()
                        
                        Button {
                            viewModel.deleteUserDefaultsData()
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
                                    Text("ЗАРЕГЕСТРИРОВАТЬСЯ")
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
                            Button {
                                //
                            } label: {
                                Image("ImageImage")
                                    .resizable()
                                    .frame(width: 32, height: 26)
                                    .padding(.horizontal)
                                    .padding(.top)
                            }
                            .padding(.bottom,4)
                            Button {
                                //
                            } label: {
                                Image("Eye")
                                    .resizable()
                                    .frame(width: 35, height: 26)
                            }
                            .opacity(0.44)
                            
                            
                        }
                    }
                    
                    Spacer()
                    
                    ProgressSheetView(passedTime: viewModel.getPassedTime(), leftTime: viewModel.getLeftTime())
                        .padding(.horizontal)
                    DemobilizationTimeView(timeBeforeDemobilization: viewModel.getRemainingDays(), demobilizationDate: viewModel.getDemobilizationDate())
                        .padding(.bottom)
                        .padding(.horizontal)
                    
                
                }
            }
            
            
        }
    }
    
    func reloadView() {
        settingsRefresh.reloadView()
    }
}


#Preview {
    HomeView()
}
