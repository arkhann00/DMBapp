//
//  EmailComfirmation.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 16.12.2024.
//

import SwiftUI

enum MailComfirmation {
    case register
    case forgetPassword
}

struct MailConfirmationView: View {
    
    @ObservedObject var viewModel:RegisterViewModel
    @Binding var path:NavigationPath
    
    @State var comfirmation:MailComfirmation = .register
        
    @State var nums:[String] = ["","","","","",""]
    @State var numsText = ""
    @State var isDisableTextField = false
    
    @State var isPresentNextView = false
    @State var isWrongCode = false
    
    @State var avatarImage:UIImage?
    @FocusState var isKeyboardActive
    @State var seconds:Int = 60
    @State var isDisableSendCode:Bool = false
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default).autoconnect()
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button {
                    path.removeLast()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("Назад")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                }
                
                Spacer()
            }
            Text("Код-пароль")
                .font(.system(size: 48, weight: .bold))
                .frame(maxWidth: .infinity,alignment: .leading)
                .foregroundStyle(.black)
            Text("Введите код, который пришел Вам на почту")
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity,alignment: .leading)
                .foregroundStyle(.gray)
            
            
            
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
            
            if viewModel.viewState == .failureEmailVerify || viewModel.viewState == .failureVerifyPasswordReset {
                Text("Неверный код")
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .foregroundStyle(.red)
            }
            
            Spacer()
            
            HStack {
                
                Button {
                    if isDisableSendCode {
                        
                    } else {
                        if comfirmation == .register {
                            Task {
                                await viewModel.sendCodeToEmail()
                            }
                        } else {
                            Task {
                                await viewModel.sendPasswordResetOtpAgain()
                            }
                        }
                        isDisableSendCode = true
                        numsText = ""
                        nums = ["","","","","",""]
                        seconds = 60
                    }
                } label: {
                    if isDisableSendCode {
                        Capsule()
                            .frame(height: 61)
                            .foregroundStyle(Color.dmbWhite)
                            .overlay {
                                Text("Отправить еще раз через \(seconds) c")
                                    .foregroundStyle(.gray)
                                    .bold()
                            }
                    } else {
                        Capsule()
                            .frame(height: 61)
                            .foregroundStyle(Color.dmbRed)
                            .overlay {
                                Text("Отправить код ещё раз")
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        
                    }
                }
                .padding(.bottom)
                .disabled(isDisableTextField)
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
            
            
            if numsText.count == 6 {
                ProgressView()
                    .onAppear(perform: {
                        isDisableTextField = true
                        if comfirmation == .register {
                            Task {
                                await viewModel.mailConfirmation(num: Int(nums[0] + nums[1] + nums[2] + nums[3] + nums[4] + nums[5])!, avatarImage: avatarImage)
                            }
                        } else {
                            Task {
                                await viewModel.verifyPasswordResetOtp(otp: Int(nums[0] + nums[1] + nums[2] + nums[3] + nums[4] + nums[5])!)
                            }
                        }
                    })
                    .padding()
                
            }
            
        }
        .padding()
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
        .onChange(of: viewModel.viewState) { val in
            switch val {
            case .successEmailVerify:
                path.append(MenuCoordinatorEnum.userStatus)
            case .successVerifyPasswordReset:
                path.append(MenuCoordinatorEnum.resetPassword)
            case .failureEmailVerify, .failureVerifyPasswordReset:
                numsText = ""
                isDisableTextField = false
                
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
    MailConfirmationView(viewModel: RegisterViewModel(), path: .constant(NavigationPath()))
}
