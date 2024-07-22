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
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    Spacer()
                    Button {
                        viewModel.addNewEvent(description: eventDescription, date: eventDate)
                        dismiss()
                    } label: {
                        Text("Далее".localize(language: viewModel.getLanguage()))
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(.black)
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 23.02, height: 22)
                    }
                    .padding(.trailing, 26)
                    .padding(.bottom, 37)
                   
                    
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
                                    Text("Название события".localize(language: viewModel.getLanguage()))
                                        .frame(width: 300, alignment: .leading)
                                        .font(.custom("Montserrat", size: 17))
                                        .foregroundStyle(eventDescription == "" ? .black : .clear)
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
                                .foregroundStyle(.black)
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
                
        }
    }
}

#Preview {
    NewEventView()
        .environmentObject(CalendarViewModel())
}
