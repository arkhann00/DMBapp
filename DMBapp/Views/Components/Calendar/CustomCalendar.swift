//
//  CustomCalendar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 08.06.2024.
//

import SwiftUI

struct CustomCalendar: View {
    
    @ObservedObject var viewModel:CalendarViewModel
    
    @State var currentDate = Date().startOfMonth()
    @State var selectedDate = Date.now
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            VStack {
                HStack {
                    Button {
                        
                        withAnimation(.bouncy) {
                            currentDate = currentDate.minusMonth()
                            viewModel.getArrOfMonth(date: currentDate)
                        }
                        
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .rotationEffect(.degrees(180))
                    }
                    Text("\(currentDate.getMonthYearString(language: viewModel.getLanguage()))".localize(language: viewModel.getLanguage()))
                        .font(.custom("benzin-extrabold", size: 15))
                        .transition(.move(edge: .leading))
                    Button {
                        withAnimation(.bouncy) {
                            currentDate = currentDate.plusMonth()
                            viewModel.getArrOfMonth(date: currentDate)
                        }
                    } label: {
                        Image("BlackArrow")
                            .resizable()
                            .frame(width: 19, height: 19)
                    }
                    Spacer()
                    Button {
                        //
                    } label: {
                        Text("...")
                            .rotationEffect(.degrees(90))
                            .font(.custom("benzin-regular", size: 17))
                            .foregroundStyle(.black)
                    }
                    
                    
                }
                .padding()
                .foregroundStyle(.black)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("ПН".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("ВТ".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("СР".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("ЧТ".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("ПТ".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("СБ".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                        Text("ВС".localize(language: viewModel.getLanguage())).frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.black)
                    .font(.custom("benzin-extrabold", size: 17))
                    .padding(.top)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), content: {
                        
                        ForEach(0..<currentDate.dayOfWeek()-1, id: \.self) { _ in
                            Text("_")
                            }
                        
                        ForEach(viewModel.days) { day in
                            
                            Button  {
                            } label: {
                                ZStack {
                                    if (day.date.getDateFromString() == Date.now.getDateFromString()) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .frame(width: 31, height: 31)
                                            .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                    }
                                    Text(day.date.getOnlyDay())
                                        .foregroundStyle(day.date.getDateFromString() == Date.now.getDateFromString() ? .white : .black)
                                        .padding(.vertical,5)
                                    if (viewModel.getPossibleEvent(date: day.date) != nil) {
                                        VStack {
                                            Spacer()
                                            Spacer()
                                            Spacer()
                                            Spacer()
                                            Rectangle()
                                                .frame(width: 20,height: 1)
                                                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                                            Spacer()
                                            
                                                
                                        }
                                    }
                                }
                            }

                            
                            
                        }
                        
                    })
                    .font(.custom("Montserrat", size: 20))
                    
                    
                }
                Spacer()
            }
            
        }
    }
}

#Preview {
    CustomCalendar(viewModel: CalendarViewModel())
}
