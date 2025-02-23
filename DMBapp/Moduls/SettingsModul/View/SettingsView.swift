//
//  SettingsView.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.12.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    @Binding var path:NavigationPath
    
    @State var isBackgroundDim = true
    
    @State var isPresentAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            
                Button {
                    path.removeLast()
                } label: {
                    Image(Images.leadingArrow())
                        .resizable()
                        .frame(width: 20, height: 19)
                    Text("Меню")
                        .foregroundStyle(Color(red: 131/255, green: 131/255, blue: 131/255))
                }
            
            Text("Настройки")
                .font(.system(size: 48, weight: .bold))
                .frame(alignment: .leading)
                .foregroundStyle(.black)
            
            HStack {
                
                Image(Images.backgroundDimIcon())
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text("Затемнение фона")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
                
                Toggle("", isOn: $isBackgroundDim)
                    .toggleStyle(ColoredToggleStyle(onColor: Color.dmbWhite, offColor: Color.dmbWhite, thumbColor:  isBackgroundDim ? Color(red: 52/255, green: 168/255, blue: 83/255) : .red, complition: {
                        viewModel.isBackgroundDim.toggle()
                        Task {
                            await viewModel.updateSettings()
                        }
                    }))
                    .frame(width: 80)
                    
            }
            
            Rectangle()
                .foregroundStyle(Color.dmbWhite)
                .frame(height: 1)
            
            Button {
                isPresentAlert = true
            } label: {
                
                HStack {
                    Image(Images.removeBackgroundIcon())
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Сбросить задний фон")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.black)
                    if viewModel.viewState == .loadingRemoveBackgroundImage {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
            .alert("Вы уверены, что хотите это сделать", isPresented: $isPresentAlert) {
                Button("Отмена", role: .cancel) {}
                Button("Да", role: .none) {
                    Task {
                        await viewModel.removeBackground()
                    }
                }
                
            }
            
            Rectangle()
                .foregroundStyle(Color.dmbWhite)
                .frame(height: 1)
            
            Button {
                path.append(MenuCoordinatorEnum.changeTimer)
            } label: {
                HStack {
                    Image(Images.timerSettingsIcon())
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Настройки таймера")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
            Rectangle()
                .foregroundStyle(Color.dmbWhite)
                .frame(height: 1)
            
            Spacer()
        }
        .onChange(of: viewModel.viewState) { state in
            
            switch state {
            case .failureSavingSettings:
                viewModel.isBackgroundDim.toggle()
            case .successSavingSettings:
                isBackgroundDim = viewModel.isBackgroundDim
            default: break
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .colorScheme(.light)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .onAppear {
            isBackgroundDim = viewModel.isBackgroundDim
        }
        
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    var complition: () -> ()
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text (label)
            Spacer ()
            Button(action: {
                configuration.isOn.toggle()
                complition()
            } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding (1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation (Animation.easeInOut (duration: 0.1))
            }
        }
        .font(.title)
        
        
    }
}

#Preview {
    SettingsView(path: .constant(NavigationPath()))
}
