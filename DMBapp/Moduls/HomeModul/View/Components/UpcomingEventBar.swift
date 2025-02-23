//
//  UpcomingEventBar.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import SwiftUI

struct UpcomingEventBar: View {
    
    @ObservedObject var viewModel:HomeViewModel
    
    @State var event:Event?
    
    var upcomingEventComplition: () -> () = {}
    
    var body: some View {
        
        HStack {
            
            VStack(alignment:.leading) {
                HStack {
                    Image("redStar")
                        .resizable()
                        .frame(width: 8, height: 8)
                    Text("Событие")
                        .foregroundStyle(.white)
                        .opacity(0.5)
                        .font(.manrope(size: 12, weight: .regular))
                }
                if viewModel.isDMBEnd() {
                    Text("Демобилизация!")
                        .foregroundStyle(.white)
                        .font(.manrope(size: 16, weight: .bold))
                } else {
                    if let date = event?.date, let text = event?.text {
                        Text("Через \(Int(date.timeIntervalSince(Date.now))/60/60/24) дней \(text)")
                            .foregroundStyle(.white)
                            .font(.manrope(size: 16))
                    }
                    else {
                        Text("Нет ближайших событий")
                            .foregroundStyle(.white)
                            .font(.manrope(size: 16))
                    }
                }
            }
            Spacer()
            if event != nil {
               
                NavigationLink {
                    CalendarView(path: .constant(NavigationPath()),tabBar:"home")
                        .navigationBarBackButtonHidden()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .opacity(0.1)
                        .frame(width: 52,height: 52)
                        .overlay {
                            Image("rightArrow")
                        }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.dmbBlack)
                .opacity(0.5)
        }
        
        .onAppear {
            event = viewModel.findNearestEvent()
        }
        
        
    }
}

#Preview {
    UpcomingEventBar(viewModel: HomeViewModel())
}
