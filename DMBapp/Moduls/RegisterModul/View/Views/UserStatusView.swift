//
//  UserStatusView.swift
//  DMBapp
//
//  Created by Арсен Хачатрян on 24.01.2025.
//

import SwiftUI

struct UserStatusView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var select:Int?
    
    var body: some View {
        VStack {
            Text("Кто вы?")
                .font(.manrope(size: 48, weight: .bold))
                .frame(maxWidth: .infinity,alignment: .leading)
                .foregroundStyle(.black)
            Text("Выберите один из пунктов")
                .font(.manrope(size: 16, weight: .regular))
                .frame(maxWidth: .infinity,alignment: .leading)
                .foregroundStyle(.gray)
            
            Spacer()
            
            
            VStack {
                HStack {
                    Button {
                        if select == 1 {
                            select = nil
                        } else {
                            select = 1
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.dmbRed, lineWidth: 1)
                            .frame(width: 170, height: 170)
                            
                            .overlay(alignment: .topLeading) {
                                Circle()
                                    .foregroundStyle(select == 1 ? Color.dmbRed : .black)
                                    .frame(width: 10, height: 10)
                                    .padding(15)
                                    
                            }
                            .overlay(alignment: .bottomLeading) {
                                Text("Солдат")
                                    .foregroundStyle(select == 1 ? Color.dmbRed : .black)
                                    .font(.manrope(size: 18))
                                    .padding(15)
                            }
                    }
                    
                    Button {
                        if select == 2 {
                            select = nil
                        } else {
                            select = 2
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.dmbRed, lineWidth: 1)
                            .frame(width: 170, height: 170)
                            
                            .overlay(alignment: .topLeading) {
                                Circle()
                                    .foregroundStyle(select == 2 ? Color.dmbRed : .black)
                                    .frame(width: 10, height: 10)
                                    .padding(15)
                                    
                            }
                            .overlay(alignment: .bottomLeading) {
                                Text("Жду солдата")
                                    .foregroundStyle(select == 2 ? Color.dmbRed : .black)
                                    .font(.manrope(size: 18))
                                    .padding(15)
                            }
                    }
                    
                        
                }
                
                Button {
                    if select == 3 {
                        select = nil
                    } else {
                        select = 3
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.dmbRed, lineWidth: 1)
                        .frame(width: 350, height: 100)
                        
                        .overlay(alignment: .topLeading) {
                            Circle()
                                .foregroundStyle(select == 3 ? Color.dmbRed : .black)
                                .frame(width: 10, height: 10)
                                .padding(15)
                                
                        }
                        .overlay(alignment: .bottomLeading) {
                            Text("Другое")
                                .foregroundStyle(select == 3 ? Color.dmbRed : .black)
                                .font(.manrope(size: 18))
                                .padding(15)
                        }
                }
                
                Button {
                    switch select {
                    case 1:
                        viewModel.saveStatus(status: "Солдат")
                        path.append(MenuCoordinatorEnum.startAvatarImage)
                    case 2:
                        viewModel.saveStatus(status: "Жду солдата")
                        path.append(MenuCoordinatorEnum.startAvatarImage)
                    case 3:
                        viewModel.saveStatus(status: "Жду солдата")
                        path.append(MenuCoordinatorEnum.startAvatarImage)
                    default:
                        path.append(MenuCoordinatorEnum.startAvatarImage)
                        
                    }
                } label: {
                    Text(select == nil ? "Пропустить" : "Продолжить")
                        .foregroundStyle(.black)
                        .font(.manrope(size: 18))
                        .padding()
                        .background {
                            Capsule()
                                .foregroundStyle(Color.dmbWhite)
                        }
                }
                .padding()
                
            }
            
        }
        .padding()
        .background {
            Color.white.ignoresSafeArea()
        }
    }
}

#Preview {
    UserStatusView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
