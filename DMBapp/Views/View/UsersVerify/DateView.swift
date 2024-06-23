//
//  DateView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 23.05.2024.
//

import SwiftUI

struct DateView: View {
    
    @ObservedObject var viewModel = RegisterViewModel()
    
    private let realm = RealmManager.shared

    @State var isSaved = false
    @State var isPresentAlert = false
    
    @Environment (\.dismiss) var dismiss
    
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
                    }
                    .rotationEffect(.degrees(180))
                    .padding(.leading, 26)
                    .padding(.bottom, 37)
                    
                    Spacer()
                }
                
                Text("ДОБАВЛЕНИЕ СОЛДАТА")
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
                            Text("Дата призыва:")
                                .font(.custom("Montserrat", size: 17))
                                .foregroundStyle(.black)
                            Spacer()
                            DatePick(date: $viewModel.startDate)
                                .onChange(of: viewModel.startDate) {
                                    viewModel.startDateWasChanged()
                                }
                        }
                        .frame(width: 311, height: 21)
                        Rectangle()
                            .frame(width: 310, height: 1)
                            .padding(.top, 6)
                            .foregroundStyle(.black)
                        
                        HStack {
                            Text("Дата дембеля:")
                                .font(.custom("Montserrat", size: 17))
                                .foregroundStyle(.black)
                            Spacer()
                            DatePick(date: $viewModel.endDate)
                                
                            
                        }
                        .frame(width: 311, height: 21)
                        Rectangle()
                            .frame(width: 310, height: 1)
                            .padding(.top, 6)
                            .foregroundStyle(.black)
                    }
                    
                }
                
                Button {
                    if viewModel.isDatesValid() {
                        isSaved = true
                        viewModel.setStartDate()
                        viewModel.setEndDate()
                        viewModel.isDataSaved()
                    }
                    else { isPresentAlert = true }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 193, height: 42)
                        Text("СОХРАНИТЬ")
                            .font(.custom("benzin-extrabold", size: 20))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.top, 59)
                .foregroundStyle(Color(red: 180/255, green: 0, blue: 0))
                .navigationDestination(isPresented: $isSaved) {
                    
                    withAnimation(.default) {
                        CustomTabBar()
                            .navigationBarBackButtonHidden()
                    }
                        
                            
                    
                }
                .alert(Text("Ошибка"), isPresented: $isPresentAlert) {
                    Button("OK", role: .cancel) {
                    }
                } message: {
                    Text("Дата призыва должна быть раньше даты дембеля")
                }

                
                
                
                
                
                Spacer()
            }
            .background(.white)
                
        }
        .navigationBarBackButtonHidden()
    }
    
}

struct DatePick: View {
    
    @Binding var date:Date
    @State var dateForm = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }
    
    
    
    var body: some View {
        ZStack(alignment: .center) {
            DatePicker("", selection: $date, displayedComponents: .date)
                .blendMode(.destinationOver)
               
            TextField("", text: .constant(dateForm().string(from: date)))
                .disabled(true)
                .frame(maxWidth: .infinity )
                .font(.custom("Montserrat", size: 17))
                .foregroundStyle(.black)
                .padding()
            }
            
            
            
            
    }
}


struct DateView_Previews: PreviewProvider {
    
    static var previews: some View {
        DateView()
    }
}
