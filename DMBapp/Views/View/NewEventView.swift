//
//  NewEventView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.06.2024.
//

import SwiftUI

struct NewEventView: View {
    
    @ObservedObject var viewModel = CalendarViewModel()
    
    @State var eventDescription = ""
    @State var eventDate = Date.now
    
    @State var isDescriptionEmpty = false
    @State var isDateIncorrect = true
    
    @State var isShowError = false
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23.02, height: 22)
                            .rotationEffect(.degrees(180))
                    }
                    .padding(.leading, 26)
                    .padding(.bottom, 37)
                    Spacer()
                    Button {
                        if !eventDescription.isEmpty && eventDate.timeIntervalSince1970 > Date.now.timeIntervalSince1970 {
                            viewModel.addNewEvent(description: eventDescription, date: eventDate)
                            
                        }
                        if eventDescription.isEmpty {
                            isDescriptionEmpty = true
                        } else { isDescriptionEmpty = false }
                        if eventDate.timeIntervalSince1970 > Date.now.timeIntervalSince1970 {
                            isDateIncorrect = true
                        } else { isDateIncorrect = false }
                    } label: {
                        Text("Далее".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(.black)
//                        Image("BlackArrow")
//                            .resizable()
//                            .frame(width: 23.02, height: 22)
                    }
                    .padding(.trailing, 26)
                    .padding(.bottom, 37)
                    .onChange(of: viewModel.viewState) { _ in
                        if viewModel.viewState == .success {
                            dismiss()
                        }
                        if viewModel.viewState == .failure {
                            isShowError = true
                        }
                    }
                    
                }
                
                Text("ДОБАВЛЕНИЕ СОБЫТИЯ".localize(language: viewModel.getLanguage()))
                    .foregroundStyle(.black)
                    .font(.custom("benzin-extrabold", size: 20))
                Rectangle()
                    .frame(width: 336, height: 1)
                    .padding(.top, 19)
                    .padding(.bottom, 30)
                    .foregroundStyle(.black)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: 333,height: 128)
                        .foregroundStyle(.black)
                    VStack{
                        
                        HStack {
                            
                            TextField("", text: $eventDescription)
                                .font(.custom("Montserrat", size: 17))
                                .foregroundStyle(.black)
                                .background {
                                    if eventDescription.isEmpty {
                                        Text("Название события".localize(language: viewModel.getLanguage()))
                                            .frame(width: 300, alignment: .leading)
                                            .font(.custom("Montserrat", size: 17))
                                            .foregroundStyle(isDescriptionEmpty ? .red : .black)
                                    }
                                }
                                
                               
                            Spacer()
                        }
                        .frame(width: 311, height: 21)
                        Rectangle()
                            .frame(width: 310, height: 1)
                            .padding(.vertical, 6)
                            .foregroundStyle(.black)
                        
                        HStack {
                            Text("Дата события:".localize(language: viewModel.getLanguage()))
                                .font(.custom("Montserrat", size: 17))
                                .foregroundStyle(!isDateIncorrect ? .red : .black)
                            Spacer()
                            DatePick(date: $eventDate)
                            
                        }
                        
                        .frame(width: 311, height: 21)
                        Rectangle()
                            .frame(width: 310, height: 1)
                            .padding(.top, 6)
                            .foregroundStyle(.black)
                    }
                    
                }
            


                
                
                
                
                
                Spacer()
            }
            .background(.white)
            .overlay {
                if isShowError {
                    EventErrorView(isPresented: $isShowError)
                }
            }
        }
    }
}

#Preview {
    NewEventView()
        .environmentObject(CalendarViewModel())
}
