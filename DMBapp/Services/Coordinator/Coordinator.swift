//
//  Coordinator.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import Foundation
import Combine
import SwiftUI

class Coordinator: ObservableObject {
    
    @Published var path: NavigationPath = NavigationPath()
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
//    @ViewBuilder
//    func build(page:AppPages) -> some View {
//        switch page {
//        case .home: HomeView()
//        case .shareTimer: break
//        case .chats: ChatsView()
//        case .generalChat: break
//        case .directChat: break
//        case .userCard: break
//        case .menu: MenuView()
//        case .profile: break
//        case .friends: break
//        case .calendar: break
//        case .settings: break
//        case .changeBackground: break
//        case .register: break
//        case .authorize: break
//        case .changeTimer: break
//        case .emailComfirmation: break
//            
//        }
//    }
    
}
