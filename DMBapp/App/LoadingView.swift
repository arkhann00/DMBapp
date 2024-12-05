//
//  LoadingView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 14.08.2024.
//

import SwiftUI

struct LoadingView: View {
    
    @State var viewState:ViewState = .loading
    let userDefaults = UserDefaultsManager.shared
    let keychain = KeychainManager.shared
    let networkManager = NetworkManager()
    @State var isDataSaved:Bool? = nil
    
    var body: some View {
        ZStack {
            if isDataSaved == nil {
                VStack {
                    Image("redLogo")
                        .resizable()
                        .frame(width: 229, height: 230)
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Rectangle()
                        .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                        .ignoresSafeArea()
                    
                }
            } else if isDataSaved == false {
                UseTermsView()
            }
            else if isDataSaved == true {
                CustomTabBar()
            }
            
        }
        .onAppear(perform: {
            print(keychain.load(key: .accessToken))
            if userDefaults.date(forKey: .startDate) != nil && userDefaults.date(forKey: .endDate) != nil {
                Task {
                    await networkManager.updateTokens { response in
                        let result = response.result
                        switch result {
                        case .success(let success):
                            print(success.accessTokenExpiresAt)
                            let _ = keychain.save(key: .accessToken, value: success.accessToken)
                            let _ = keychain.save(key: .refreshToken, value: success.refreshToken)
                            userDefaults.set(success.accessTokenExpiresAt, forKey: .accessTime)
                            userDefaults.set(success.refreshTokenExpiresAt, forKey: .refreshTime)
                            
                            networkManager.getTimer { result in
                                switch result {
                                case .success(let success):
                                    viewState = .online
                                    isDataSaved = true
                                case .failure(let failure):
                                    break
                                }
                            }
                        case .failure(_):
                            if let data = response.data {
                                do {
                                    let error = try JSONDecoder().decode(NetworkError.self, from: data)
                                    print(error)
                                } catch {
                                    print(response)
                                }
                            }
                            viewState = .offline
                            isDataSaved = true
                        }
                    }
                }
            } else {
                viewState = .offline
                isDataSaved = false
            }
        })
    }
    
}


#Preview {
    LoadingView()
}
