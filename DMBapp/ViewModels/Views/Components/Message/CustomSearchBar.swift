//
//  CustomSearchBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @ObservedObject var viewModel:MessageViewModel
    
    @State var searchedText = ""
    @State var isEditing = false
    @FocusState var focusOnKeyBoard:Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
                .frame(width: 380, height: 33)
                .padding()
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                TextField("", text: $searchedText)
                    .font(.custom("Montserrat", size: 20))
                    .padding(.horizontal,3)
                    .focused($focusOnKeyBoard)
                    .foregroundStyle(.black)
                    .onTapGesture {
                        isEditing = true
                        
                    }
                    .background(alignment: .leading) {
                        Text("Найти пользователя".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 20))
                            .padding(.leading, 3)
                            .foregroundStyle(isEditing == false ? .black : .clear)
                            .transaction { transaction in
                                transaction.animation = .default
                            }
                    }
                        
                    
                if isEditing {
                    withAnimation(.default) {
                        Button {
                            focusOnKeyBoard = false
                            isEditing = false
                            searchedText = ""
                            
                        } label: {
                            Text("Отмена")
                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                .font(.custom("Monsterrat", size: 20))
                        }
                        .padding(.trailing)
                        .transition(.move(edge: .trailing))
                    }
                    
                    
                }
            }
            .padding()
        }
    }
}

#Preview(traits:.sizeThatFitsLayout) {
    CustomSearchBar(viewModel: MessageViewModel())
}
