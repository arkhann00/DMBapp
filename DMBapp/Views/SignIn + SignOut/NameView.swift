//
//  FirstAndSecondNamesView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 10.07.2024.
//

import SwiftUI

struct NameView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    
    @Environment (\.dismiss) var dismiss
    
    @State var mail:String
    @State var password:String
    @State var name = ""
    @State var nick = ""
    
    @State var isPresentNextView = false
    @State var isPresentErrorAlert = false
    @State var isPresentImagePicker = false
    @State var pickerImage:UIImage?
    
    @FocusState var nameEditing
    @FocusState var nickEditing
    
    init(viewModel: RegisterViewModel, mail: String, password: String) {
        self.viewModel = viewModel
        self.mail = mail
        self.password = password
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.viewState == .loading {
                CustomActivityIndicator()
            }
            else if viewModel.viewState == .none || viewModel.viewState == .offline {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 23.02, height: 22)
                        }
                        .rotationEffect(.degrees(180))
                        
                        Spacer()
                        Button {
                            viewModel.registerAccount(mail: mail, password: password, name: name, nickname: nick, avatarImage: pickerImage)
                            if viewModel.viewState == .online {
                                isPresentNextView = true
                            }
                            if viewModel.viewState == .offline {
                                isPresentErrorAlert = true
                            }
                        } label: {
                            Text("Далее".localize(language: viewModel.getLanguage()))
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat", size: 12))
                            Image("BlackArrow")
                                .resizable()
                                .frame(width: 17,height: 16 )
                        }
                        .navigationDestination(isPresented: $isPresentNextView) {
                            EmailConfirmationView(viewModel: viewModel, mail: mail, avatarImage: pickerImage)
                        }
                        .alert("ЧТО-ТО ПОШЛО НЕ ТАК".localize(language: viewModel.getLanguage()), isPresented: $isPresentErrorAlert) {
                            Button(role: .cancel) {} label: {
                                Text("OK")
                            }

                        }
                        
                    }
                    .padding()
                    .padding(.bottom)
                    
                    Text("ПРОФИЛЬ".localize(language: viewModel.getLanguage()))
                        .foregroundStyle(.black)
                        .font(.custom("benzin-extrabold", size: 32))
                        .shadow(radius: 2, x: 0, y: 4)
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    
                    TextField("", text: $name)
                        .padding(20)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .foregroundStyle(.black)
                        .background(alignment: .leading) {
                            
                            Text("Имя".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!nameEditing && name.isEmpty ? .black : .clear)
                                .padding()
                                
                                
                        }
                        .focused($nameEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(13)
                        }
                    
                    TextField("", text: $nick)
                        .padding(20)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat", size: 17))
                        .background(alignment: .leading) {
                            Text("Ник-нейм".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .padding(.leading, 3)
                                .foregroundStyle(!nickEditing && nick.isEmpty ? .black : .clear)
                                .padding()
                                
                                
                        }
                        .focused($nickEditing)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .padding(13)
                        }
                        .padding(.top, -15)
                    Text("Латинские символы и числа от 4 до 30 символов".localize(language: viewModel.getLanguage()))
                        .padding(.top, -20)
                        .foregroundStyle(Color(.gray))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.custom("Montserrat", size: 14))
                        .padding(.horizontal)
                    if pickerImage == nil {
                        CustomAddButton()
                            .padding(.top, 60)
                            .onTapGesture {
                                isPresentImagePicker = true
                            }
                            .sheet(isPresented: $isPresentImagePicker, content: {
                                AvatarImagePicker(image: $pickerImage)
                            })
                        Text("Добавить фотографию".localize(language: viewModel.getLanguage()))
                            .foregroundStyle(.black)
                            .font(.custom("Montserrat", size: 20))
                            .padding()
                    }
                    else {
                        Button {
                            isPresentImagePicker = true
                        } label: {
                            Image(uiImage: pickerImage!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 71)
                                .foregroundStyle(Color(red: 46/255, green: 40/255, blue: 40/255))
                                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 1-0.25), radius: 4, x: 2, y: 4)
                        }

                    }
                    Spacer()
                }
                .onAppear(perform: {
//                    if viewModel.viewState == .online {
//                        isPresentNextView = true
//                    }
                    if viewModel.viewState == .offline {
                        isPresentErrorAlert = true
                    }
                    viewModel.viewState = .none
                    
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color(.white)
                        .ignoresSafeArea()
                }
            }
            else if viewModel.viewState == .online {
                EmailConfirmationView(viewModel: viewModel, mail: mail, avatarImage: pickerImage)
                    
                    
            }
            
        }
    }
}

#Preview {
    NameView(viewModel: RegisterViewModel(), mail: "", password: "")
}
