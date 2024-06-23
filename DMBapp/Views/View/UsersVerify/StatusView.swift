//
//  StatusView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI

struct StatusView: View {
    
    @ObservedObject var viewModel = RegisterViewModel()
    @State var selectedStatus:Int?
    @State var isPresented = false

    var statuses = ["Солдат", "Офицер", "Курсант", "Родственник солдата"]
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack{
                    Spacer()
                    Button {
                        if (selectedStatus != nil) {
                            viewModel.setSatus(status: statuses[selectedStatus!])
                        }
                        isPresented = true
                    } label: {
                        Text(selectedStatus != nil ? "Далее" : "Пропустить")
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(.black)
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 17,height: 16)
                    }
                    .navigationDestination(isPresented: $isPresented, destination: {
                        DateView()
                    })
                    .padding(.trailing, 22)
                }
                HStack {
                    Text("КТО ВЫ?")
                        .foregroundStyle(.black)
                        .font(.custom("benzin-extrabold", size: 24))
                    
                        .padding()
                    Spacer()
                }
                .padding(.leading, 28)
                VStack{
                    ForEach(0..<4) { num in
                        Button {
                            selectedStatus = num
                            isPresented = true
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 354, height: 33)
                                    .foregroundStyle(
                                        selectedStatus == num ?
                                        Color(red: 180/255, green: 0, blue: 0) :
                                            Color(red: 242/255, green: 242/255, blue: 242/255))
                                Text(statuses[num])
                                    .frame(width: 334, alignment: .leading)
                                    .font(.custom("Montserrat", size: 20))
                                    .foregroundStyle(
                                        selectedStatus == num ?
                                        Color(.white) :
                                            Color(.black)
                                    )
                            }
                        }
                        
                    }
                    .padding(.bottom, 15)
                }
                .padding(.horizontal,18)
                Spacer()
            }
            .background(Color(.white))
        }
        // rgba(242, 242, 242, 1)
        // rgba(180, 0, 0, 1)
    }
}

#Preview {
    StatusView()
}
