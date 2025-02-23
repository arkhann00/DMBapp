//
//  ProgressSheet.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.05.2024.
//

import SwiftUI

struct ProgressSheetView: View {
    
    @ObservedObject var viewModel:HomeViewModel
    @State var passedTime: (Int,Int,Int,Int)
    @State var leftTime: (Int,Int,Int,Int)
    @State var language:String
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default).autoconnect()
    
    init(viewModel:HomeViewModel, language:String, passedTime: (Int,Int,Int,Int), leftTime: (Int,Int,Int,Int)) {
        self.viewModel = viewModel
        self.language = language
        self.passedTime = passedTime
        self.leftTime = leftTime
    }
    
    var body: some View {
        ZStack(alignment:.bottom) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                .frame(height: 135)
                .frame(maxWidth: .infinity)
                .padding(.bottom,5)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .frame(height: 124)
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Spacer()
                    VStack  (alignment:.leading){
                        Text("ПРОШЛО".localize(language: language))
                            .font(.custom("benzin-extrabold", size: 12))
                            .foregroundStyle(.black)
                            .padding(.bottom, 3)
                            
                            Text("\(passedTime.0) "+"дней".localize(language: language))
                                .font(.custom("Montserrat", size: 12))
                                .foregroundStyle(.black)
                            Text("\(passedTime.1) " + "часов".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                            Text("\(passedTime.2) "+"минут".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                            Text("\(passedTime.3) "+"секунд".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                                .padding(.bottom)
                        
                        Text("УЖЕ ПРОШЛО".localize(language: language))
                            .font(.custom("benzin-extrabold", size: 8))
                            .foregroundStyle(Color(red: 130/255, green: 93/255, blue: 93/255, opacity: 0.69))
                        
                    }
                    .padding()
                    Spacer()
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 1, height: 78)
                        .foregroundStyle(.black)
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("ОСТАЛОСЬ".localize(language: language))
                            .font(.custom("benzin-extrabold", size: 12))
                            .foregroundStyle(.black)
                            .padding(.bottom, 3)
                            
                            Text("\(leftTime.0) " + "дней".localize(language: language))
                                .font(.custom("Montserrat", size: 12))
                                .foregroundStyle(.black)
                            Text("\(leftTime.1) " + "часов".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                            Text("\(leftTime.2) " + "минут".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                            Text("\(leftTime.3) " + "секунд".localize(language: language))
                                .font(.custom("Montserrat", size: 7))
                                .foregroundStyle(.black)
                                .padding(.bottom)
                        
                        Text("ЕЩЁ ОСТАЛОСЬ".localize(language: language))
                            .font(.custom("benzin-extrabold", size: 8))
                            .foregroundStyle(Color(red: 130/255, green: 93/255, blue: 93/255, opacity: 0.69))
                    }
                    Spacer()
                }
                .onReceive(timer, perform: { timer in
                    
                    if leftTime.3 >= 0 {
                        leftTime.3 -= 1
                    }
                    if leftTime.3 < 0 {
                        leftTime.3 = 59
                        leftTime.2-=1
                    }
                    if leftTime.2 < 0 {
                        leftTime.2 = 59
                        leftTime.1-=1
                    }
                    if leftTime.1 < 0 {
                        leftTime.1 = 23
                        leftTime.0-=1
                    }
                    
                    if passedTime.3 < 60 {
                        passedTime.3 += 1
                    }
                    if passedTime.3 == 60 {
                        passedTime.3 = 0
                        passedTime.2+=1
                    }
                    if passedTime.2 == 60 {
                        passedTime.2 = 0
                        passedTime.1+=1
                    }
                    if passedTime.1 == 24 {
                        passedTime.1 = 0
                        passedTime.0+=1
                    }
                    
                })
                .frame(width: 358)
                .onAppear(perform: {
                    language = viewModel.getLanguage()
                })
            }
            
        }
    }
}

#Preview {
    ProgressSheetView(viewModel: HomeViewModel(), language: "default", passedTime: (60, 22, 18, 57), leftTime: (305, 1, 7, 4))
    
}
