//
//  TabViewCoordinator.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import Foundation

class TabViewCoordinator: ObservableObject {
    
    @Published var selectedTab: Tab = .home
        
    enum Tab: Hashable {
        case home
        case chats
        case menu
    }
}
