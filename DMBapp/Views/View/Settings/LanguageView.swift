//
//  LanguageView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 12.06.2024.
//

import SwiftUI

struct LanguageView: View {
    
    @State var isAlertPresented = false
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23, height: 22)
                    }
                    .padding(.horizontal)
                    
                }
                VStack(alignment:.leading) {
                    Text("Язык")
                        .font(.custom("benzin-extrabold", size: 24))
                        .foregroundStyle(.black)
                        .padding(.bottom, 5)
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(height: 1)
              
                }
                .padding()
                
                Button {
                    
                } label: {
                    Text("Русский")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.white)
                                .border(.black, width: 1)
                                .padding(-6)
                                
                        }
                }
                .padding()
                Button {
                    isAlertPresented = true
                } label: {
                    Text("English")
                        .font(.custom("benzin-regular", size: 16))
                        .foregroundStyle(.black)
                        
                }
                .alert("СКОРО", isPresented: $isAlertPresented) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("OK")
                    }

                }

                
                Spacer()
            }
        }
    }
}

#Preview {
    LanguageView()
}
