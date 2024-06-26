//
//  CustomTabBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @State var selectedTab = 0
    @FocusState var isKeyBoardActive:Bool
    @EnvironmentObject var calendarViewModel:CalendarViewModel
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color(selectedTab == 2 ? .white : .black)
                    .ignoresSafeArea()
                VStack {
                    
                    switch selectedTab {
                    case 0:
                        
                        HomeView()
                            .overlay {
                                VStack {
                                    HStack{
                                        NavigationLink {
                                            SettingsView()
                                                .navigationBarBackButtonHidden()
                                        } label: {
                                            Image("Settings")
                                                .resizable()
                                                .frame(width: 32, height: 26)
                                        }
                                        .padding()
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                    case 1:
                        MessageView()
                            .focused($isKeyBoardActive)
                            .overlay {
                                VStack {
                                    HStack{
                                        NavigationLink {
                                            SettingsView()
                                                .navigationBarBackButtonHidden()
                                        } label: {
                                            Image("Settings")
                                                .resizable()
                                                .frame(width: 32, height: 26)
                                        }
                                        .padding()
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                    case 2:
                        CalendarView()
                    default:
                        EmptyView()
                    }
                    Spacer()
                    if !isKeyBoardActive {
                        HStack {
                            Spacer()
                            
                            Button {
                                    selectedTab = 0
                            } label: {
                                Image(selectedTab == 0 ? "redHouse" : "whiteHouse")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding(.top)
                            
                            Spacer()
                            
                            Button {
                                    selectedTab = 1
                            } label: {
                                Image(selectedTab == 1 ? "redMessage" : "whiteMessage")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding(.top)
                            
                            Spacer()
                            
                            Button {
                                selectedTab = 2
                            } label: {
                                Image(selectedTab == 2 ? "redCalendar" : "whiteCalendar")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding(.top)
                            
                            Spacer()
                        }
                        .background(.black)
                        .frame(height: 40)
                    }
                    
                }
                
            }
            
            
        }
        

    }
            
    
    
    
}

#Preview {
    CustomTabBar()
        .environmentObject(CalendarViewModel())
}
