//
//  UserCardView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 19.08.2024.
//

import SwiftUI

struct UserCardView: View {
    
    @State var user:UserData
    @ObservedObject var viewModel:HomeViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image("BlackArrow")
                        .resizable()
                        .frame(width: 23, height: 22)
                }
                
                
            }
            .padding(.horizontal)
            HStack {
                if let imageUrl = user.avatarImageName {
                    CustomImageView(imageUrl: imageUrl)
                        .frame(width: 94, height: 94)
                }
                else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundStyle(.black)
                        .frame(width: 94, height: 94)
                }
                VStack(alignment:.leading) {
                    Text("\(user.name)")
                        .foregroundStyle(.black)
                        .font(.custom("benzin-regular", size: 12))
                    Text("@\(user.nickname)")
                        .foregroundStyle(Color(red: 130/255, green: 93/255, blue: 93/255))
                        .font(.custom("Montserrat", size: 10))
                    Spacer()
                }
                .padding(.leading, 40)
                .frame(height: 90)
                Spacer()
            }
            .padding()
            
            HStack {
                Button {
                    if viewModel.isMyFriend(with: user.id) {
                        viewModel.deleteFromFriends(id: user.id)
                    } else {
                        viewModel.sendFriendshipInvite(id: user.id)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(viewModel.isMyFriend(with: user.id) ? Color(red: 180/255, green: 0, blue: 0) : .black)
                        Text(viewModel.isMyFriend(with: user.id) ? "Удалить из друзей".localize(language: viewModel.getLanguage()) : "Добавить в друзья".localize(language: viewModel.getLanguage()))
                            .font(.custom("benzin-regular", size: 12))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 26)
                .padding()
                
                
            }
            .onAppear {
                viewModel.fetchFriends()
            }
            Spacer()
        }
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
        
        
        
        Spacer()
        
    }
}



#Preview {
    UserCardView(user: UserData(id: 0, name: "Olef", nickname: "OOOO123"), viewModel: HomeViewModel())
}
