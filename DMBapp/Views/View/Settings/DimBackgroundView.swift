//
//  DimBackgroundView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.06.2024.
//

import SwiftUI

struct DimBackgroundView: View {

    @Environment(\.dismiss) var dismiss
    
    @State var isBackgroundDim:Bool
    
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                
            VStack {
                HStack {
                    Spacer()
                    Button {
                        HomeViewModel().isBackgroundDim = isBackgroundDim
                        dismiss()
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23, height: 22)
                    }
                    .padding(.horizontal)
                    
                }
                VStack(alignment:.leading) {
                    Text("Затемнение фона")
                        .font(.custom("benzin-extrabold", size: 24))
                        .foregroundStyle(.black)
                        .padding(.bottom, 5)
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(height: 1)
              
                }
                .padding()
                
                Button {
                    isBackgroundDim = true
                    viewModel.setBackgroundState(state: isBackgroundDim)
                } label: {
                    Text("ДА")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        .background {
                            if isBackgroundDim == true {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.white)
                                    .border(.black, width: 1)
                                    .padding(-6)
                            }
                        }
                }
                .padding()
                Button {
                    isBackgroundDim = false
                    viewModel.setBackgroundState(state: isBackgroundDim)
                } label: {
                    Text("НЕТ")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        .background {
                            if isBackgroundDim == false {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.white)
                                    .border(.black, width: 1)
                                    .padding(-6)
                            }
                        }
                }

                
                Spacer()
            }
        }
    }
}

#Preview {
    DimBackgroundView(isBackgroundDim: SettingsViewModel().getBackgroundState())
}
