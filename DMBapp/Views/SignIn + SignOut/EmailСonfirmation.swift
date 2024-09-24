//
//  EmailСonfirmation.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.09.2024.
//

import SwiftUI

struct EmailConfirmationView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    
    @State var nums:[String] = ["","","","","",""]
    @State var numsText = ""
    @State var isDisableTextField = false
    
    @State var mail:String
    @State var avatarImage:UIImage?
    
    @FocusState var isKeyboardActive
    
    init(viewModel:RegisterViewModel, mail:String, avatarImage:UIImage? = nil) {
        self.viewModel = viewModel
        self.mail = mail
        self.avatarImage = avatarImage
        isKeyboardActive = true
    }
    
    var body: some View {
        if viewModel.mailComfirmationState == .loading {
            CustomActivityIndicator()
        } else if viewModel.mailComfirmationState == .none || viewModel.mailComfirmationState == .offline {
            VStack {
                Spacer()
                Text("КОД".localize(language: viewModel.getLanguage()))
                    .foregroundStyle(.black)
                    .font(.custom("benzin-extrabold", size: 32))
                    .shadow(radius: 2, x: 0, y: 4)
                Text("Введите код, который пришел Вам на почту")
                    .padding()
                    .foregroundStyle(.gray)
                    .font(.custom("Montserrat", size: 14))
                
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 0 ? "\(nums[0])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 1 ? "\(nums[1])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 2 ? "\(nums[2])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 3 ? "\(nums[3])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 4 ? "\(nums[4])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 5 ? "\(nums[5])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    
                }
                .padding()
                .overlay {
                    TextField("",text: $numsText)
                        .keyboardType(.numberPad)
                        .onChange(of: numsText) {
                            updateNums()
                        }
                        .focused($isKeyboardActive)
                        .disabled(isDisableTextField)
                        .foregroundStyle(.clear)
                        .tint(.clear)
                    
                }
                
                HStack {
                    Text("Не пришел код?")
                        .foregroundStyle(.gray)
                    Button {
                        
                        isDisableTextField = false
                        numsText = ""
                        nums = ["","","","","",""]
                        
                    } label: {
                        Text("Отправить ещё раз")
                            .foregroundStyle(Color(red:180/255, green: 0, blue: 0))
                    }
                    
                }
                .font(.custom("Montserrat", size: 17))
                Spacer()
                if numsText.count == 6 {
                    ProgressView()
                        .onAppear(perform: {
                            isKeyboardActive = false
                            isDisableTextField = true
                            viewModel.mailConfirmation(mail: mail, num: Int(nums[0] + nums[1] + nums[2] + nums[3] + nums[4] + nums[5])!, avatarImage: avatarImage)
                        })
                        .padding()
                    
                }
                Spacer()
                
            }
            .padding()
            
            .background {
                Color(.white)
                    .ignoresSafeArea()
            }
        } else if viewModel.mailComfirmationState == .online {
            CustomTabBar(viewState: .online)
        }
    }
    
    func updateNums() {
        var numsArr:[String] = []
        for num in numsText {
            numsArr.append(num.description)
        }
        
        for i in 0 ..< numsArr.count {
            nums[i] = numsArr[i]
        }
        
    }
    
}

#Preview {
    EmailConfirmationView(viewModel: RegisterViewModel(), mail: "")
}
