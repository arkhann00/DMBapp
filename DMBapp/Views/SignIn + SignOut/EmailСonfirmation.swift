//
//  EmailСonfirmation.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.09.2024.
//

import SwiftUI

struct EmailConfirmationView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var nums:[String] = ["","","","","",""]
    @State var numsText = ""
    @State var isDisableTextField = false
    
    @State var isPresentNextView = false
    @State var isWrongCode = false
    
    @State var mail:String
    @State var avatarImage:UIImage?
    @FocusState var isKeyboardActive
    @State var seconds:Int = 60
    @State var isDisableSendCode:Bool = false
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default).autoconnect()
    
    init(viewModel:RegisterViewModel, mail:String, avatarImage:UIImage? = nil) {
        self.viewModel = viewModel
        self.mail = mail
        self.avatarImage = avatarImage
        isKeyboardActive = true
    }
    
    var body: some View {
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
                .padding(.leading, 26)
                .padding(.bottom, 37)
                
                Spacer()
            }
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
            ZStack {
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 0 ? "\(nums[0])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 1 ? "\(nums[1])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 2 ? "\(nums[2])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 3 ? "\(nums[3])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 4 ? "\(nums[4])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isWrongCode ? Color(red:1, green:166/255, blue:166/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 50, height: 60)
                        .overlay {
                            Text(numsText.count > 5 ? "\(nums[5])" : "")
                                .font(.custom("Montserrat", size: 30))
                                .foregroundStyle(.black)
                        }
                    
                }
                .padding()
                TextField("",text: $numsText)
                    .keyboardType(.numberPad)
                    .onChange(of: numsText) { _ in
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
                    if isDisableSendCode {
                        
                    } else {
                        Task {
                            await viewModel.sendCodeToEmail()
                        }
                        isDisableSendCode = true
                        numsText = ""
                        nums = ["","","","","",""]
                        seconds = 60
                    }
                } label: {
                    if isDisableSendCode {
                        Text("\(seconds) c")
                            .foregroundStyle(.gray)
                            .bold()
                    } else {
                        Text("Отправить ещё раз")
                            .foregroundStyle(isDisableSendCode ? .gray : Color(red:180/255, green: 0, blue: 0))
                            .bold()
                    }
                }
                .disabled(isDisableSendCode)
                .onReceive(timer) { timer in
                    if seconds >= 0 {
                        seconds -= 1
                    } else {
                        isDisableSendCode = false
                    }
                }
                .onChange(of: seconds) { seconds in
                    if seconds == 0 {
                        isDisableSendCode = false
                    }
                }
            }
            .font(.custom("Montserrat", size: 17))
            Spacer()
            if numsText.count == 6 {
                ProgressView()
                    .onAppear(perform: {
                        isDisableTextField = true
                        Task {
                            await viewModel.mailConfirmation(mail: mail, num: Int(nums[0] + nums[1] + nums[2] + nums[3] + nums[4] + nums[5])!, avatarImage: avatarImage)
                        }
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
        .navigationDestination(isPresented: $isPresentNextView) {
            StartAvatarImageView(viewModel: viewModel)
                .navigationBarBackButtonHidden()
        }
        .onChange(of: viewModel.viewState) { val in
            switch val {
            case .successEmailVerify:
                isPresentNextView = true
            case .failureEmailVerify:
                isWrongCode = true
            default:
                break
            }
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
