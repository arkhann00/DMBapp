//
//  CustomTabView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import SwiftUI

struct CustomTabView: View {
    
    @ObservedObject private var coordinator = TabViewCoordinator()
    @State var homeNavigationPath = NavigationPath()
    @State var chatsNavigationPath = NavigationPath()
    @State var menuNavigationPath = NavigationPath()
    
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var chatsViewModel = ChatsViewModel()
    @StateObject var menuViewModel = MenuViewModel()
    @StateObject var registerViewModel = RegisterViewModel()
    
    @State var isShowTabView = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            ZStack(alignment: .bottom) {
                TabView(selection: $coordinator.selectedTab) {
                    NavigationStack {
                        HomeView(viewModel: homeViewModel, isShowTabView: $isShowTabView)
                        
                    }
                    .tabItem({
                        Text("123")
                    })
                    .tag(TabViewCoordinator.Tab.home)
                    NavigationStack {
                        ChatsView(isShowTabView: $isShowTabView,completion: .constant {
                            coordinator.selectedTab = .menu
                            menuNavigationPath.append(MenuCoordinatorEnum.signUp)
                        })
                    }
                    .tag(TabViewCoordinator.Tab.chats)
                    
                    
                    NavigationStack(path: $menuNavigationPath) {
                        MenuView(viewModel: menuViewModel, path: $menuNavigationPath)
                            .navigationDestination(for: MenuCoordinatorEnum.self) { coordinate in
                                switch coordinate {
                                case .menu:
                                    MenuView(viewModel: menuViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .calendar:
                                    CalendarView(path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .profile:
                                    ProfileView(viewModel: menuViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .friends:
                                    EmptyView()
                                case .settings:
                                    SettingsView(path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .changeTimer:
                                    ChangeDateView(viewModel: SettingsViewModel(), path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .signIn:
                                    SignInView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .signUp:
                                    SignUpView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .mailComfirmation:
                                    MailConfirmationView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .startAvatarImage:
                                    StartAvatarImageView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .userStatus:
                                    UserStatusView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .forgetPassword:
                                    ChangePasswordView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                case .verifyResetPassword:
                                    MailConfirmationView(viewModel: registerViewModel, path: $menuNavigationPath, comfirmation: .forgetPassword)
                                        .navigationBarBackButtonHidden()
                                case .resetPassword:
                                    NewPasswordView(viewModel: registerViewModel, path: $menuNavigationPath)
                                        .navigationBarBackButtonHidden()
                                }
                            }
                    }
                    .tag(TabViewCoordinator.Tab.menu)
                    
                }
                .colorScheme(.light)
                if isShowTabView {
                    HStack(alignment: .bottom) {
                        Spacer()
                        Button {
                            if coordinator.selectedTab == .home {
                                homeNavigationPath.removeLast(homeNavigationPath.count)
                            } else {
                                coordinator.selectedTab = .home
                            }
                        } label: {
                            VStack {
                                Image(coordinator.selectedTab == .home ? Images.selectedHome() : Images.unselectedHome())
                                    .resizable()
                                    .frame(width: 30, height: 26)
                                Text("Главная")
                                    .font(.manrope(size: 14))
                                    .foregroundStyle(coordinator.selectedTab == .home ? Color.dmbRed : .black)
                            }
                        }
                        
                        Spacer()
                        Button {
                            if coordinator.selectedTab == .chats {
                                chatsNavigationPath.removeLast(chatsNavigationPath.count)
                            } else {
                                coordinator.selectedTab = .chats
                            }
                        } label: {
                            VStack {
                                Image(coordinator.selectedTab == .chats ? Images.selectedMessages() : Images.unselectedMessages())
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Сообщения")
                                    .font(.manrope(size: 14))
                                    .foregroundStyle(coordinator.selectedTab == .chats ? Color.dmbRed : .black)
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            if coordinator.selectedTab == .menu {
                                menuNavigationPath.removeLast(menuNavigationPath.count)
                            } else {
                                coordinator.selectedTab = .menu
                            }
                        } label: {
                            VStack {
                                Image(coordinator.selectedTab == .menu ? Images.selectedMenu() : Images.unselectedMenu())
                                    .resizable()
                                    .frame(width: 30, height: 26)
                                Text("Меню")
                                    .font(.manrope(size: 14))
                                    .foregroundStyle(coordinator.selectedTab == .menu ? Color.dmbRed : .black)
                            }
                        }
                        
                        Spacer()
                        
                        
                    }
                    .padding(.top)
                    .frame(maxWidth: .infinity/*, maxHeight: UIScreen.main.bounds.height * 0.12*/)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.white)
                            .ignoresSafeArea()
                    }
                    .overlay(alignment: .top, content: {
                        Divider()
                    })
                    .colorScheme(.light)
                    
                }
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onChange(of: isShowTabView) { isShowTabView in
                
                hideTabBar(isHidden: isShowTabView)
                
            }
        }
    
    private func hideTabBar(isHidden: Bool) {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
            .first
        
        keyWindow?.rootViewController?.children
            .compactMap { $0 as? UITabBarController }
            .forEach { $0.tabBar.isHidden = isHidden }
    }
    
    
}

#Preview {
    CustomTabView()
}
