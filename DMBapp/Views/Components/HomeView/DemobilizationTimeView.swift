//
//  DemobilizationTimeView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 26.05.2024.
//

import SwiftUI

struct DemobilizationTimeView: View {
    
    @State var timeBeforeDemobilization:Int
    @State var demobilizationDate:String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 66)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            HStack {
                Image("BlackArrow")
                    .resizable()
                    .frame(width: 52, height: 43)
                VStack(alignment: .leading) {
                    TextField("", text: .constant("\(timeBeforeDemobilization) дней до дембеля"))
                        .disabled(true)
                        .font(.custom("benzin-extrabold", size: 12))
                        .frame(minWidth: 200, maxWidth: .infinity)
                        .foregroundStyle(.black)
                    
                    TextField("", text: .constant(demobilizationDate))
                        .padding(.top, -10)
                        .font(.custom("Montserrat", size: 9))
                        .disabled(true)
                        .foregroundStyle(.black)
                    Spacer()
                }
                .frame(width: 270, height: 43)
                
                
            }
            .padding()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DemobilizationTimeView(timeBeforeDemobilization: 300, demobilizationDate: "5 апреля 2024")
}
