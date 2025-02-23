//
//  ProcentTextField.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 09.12.2024.
//

import SwiftUI
import Combine

struct ProcentTextField: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()
    
    var isFullShow:Bool
    
    @State var cancellable: AnyCancellable?
    
    @State var numerator:Double = 1
    @State var denominator:Double = 100
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            if viewModel.isDMBStart() && !viewModel.isDMBEnd() {
                Text("\(Int(numerator/denominator * 100))")
                    .foregroundStyle(.white)
                    .font(.manrope(size: isFullShow ? 60 : 48, weight: .bold))
                Text(",\(extractFractionalPart(numerator/denominator * 100))%")
                    .foregroundStyle(.white)
                    .opacity(0.5)
                    .font(.manrope(size: isFullShow ? 32 : 24, weight: .bold))
                    .padding(.trailing)
                    .padding(.bottom, 5)
            } else if viewModel.isDMBEnd() {
                Text("100")
                    .foregroundStyle(.white)
                    .font(.manrope(size: isFullShow ? 60 : 48, weight: .bold))
                Text(",000000%")
                    .foregroundStyle(.white)
                    .opacity(0.5)
                    .font(.manrope(size: isFullShow ? 32 : 24, weight: .bold))
                    .padding(.trailing)
                    .padding(.bottom, 5)
            } else {
                Text("0")
                    .foregroundStyle(.white)
                    .font(.manrope(size: isFullShow ? 60 : 48, weight: .bold))
                Text(",000000%")
                    .foregroundStyle(.white)
                    .opacity(0.5)
                    .font(.manrope(size: isFullShow ? 32 : 24, weight: .bold))
                    .padding(.trailing)
                    .padding(.bottom, 5)
            }
        }
        .onReceive(timer, perform: { _ in
            
            guard viewModel.isDMBStart() && !viewModel.isDMBEnd() else { return }
            
            if (numerator < denominator) {
                numerator+=1
            }
            else {
                cancellable = timer.sink { _ in }
                cancellable?.cancel()
            }
        })
        .onAppear {
            numerator = viewModel.getProgressRelation().0
            denominator = viewModel.getProgressRelation().1
        }
    }
    
    func extractFractionalPart(_ number: Double) -> String {
        let fractionalPart = number - Double(Int(number))
        let fractionalString = String(format: "%.6f", fractionalPart)
        return String(fractionalString.split(separator: ".").last ?? "0")
    }

}

#Preview {
    ProcentTextField(viewModel: HomeViewModel(), isFullShow: false)
}
