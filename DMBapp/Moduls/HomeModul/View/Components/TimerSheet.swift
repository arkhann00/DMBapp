//
//  TimerSheet.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 27.12.2024.
//

import SwiftUI

struct TimerSheet: View {
    
    
    var user:LocalUser
    
    var remainDays: Int
    var totalDays: Int
    var progress: (Double, Double)
    
    var image:Image
    
    var isDMBStart:Bool
    var isDMBEnd:Bool
    
    var body: some View {
        VStack {
            HStack {
                if ViewModel().isAuthorizedUser() {
                    if let image = user.avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.black)
                    }
                    
                    Text("@\(user.nickname)")
                        .foregroundStyle(.white)
                        .font(.manrope(size: 20, weight: .semibold))
                }
                Spacer()
                Image(Images.DMBIcon())
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .padding()
            .ignoresSafeArea()
            
            
            Spacer()
            
            
            VStack {
                HStack {
                    if !isDMBStart {
                        Text("0")
                            .foregroundStyle(.white)
                            .font(.manrope(size: 80, weight: .bold))
                    } else if isDMBEnd {
                        Text("\(totalDays)")
                            .foregroundStyle(.white)
                            .font(.manrope(size: 80, weight: .bold))
                    } else {
                        Text("\(remainDays)")
                            .foregroundStyle(.white)
                            .font(.manrope(size: 80, weight: .bold))
                    }
                    Text("ДНЕЙ ДО ДЕМБЕЛЯ")
                        .foregroundStyle(.white)
                        .font(.manrope(size: 30, weight: .bold))
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .frame(height: 100)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7948717949)
                        .frame(height: 8)
                        .foregroundStyle(.white)
                        .opacity(0.2)
                    
                    if isDMBStart || isDMBEnd {
                        HStack {
                            Capsule()
                                .frame(width: progress.0 < progress.1 ? UIScreen.main.bounds.width * 0.7948717949 * (progress.0 / progress.1) : UIScreen.main.bounds.width * 0.7948717949, height: 8)
                                .foregroundStyle(.white)
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            
            .frame(height: 160)
            .padding()
            .background {
                BlurView()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .ignoresSafeArea()
                    .padding()
            }
            
        }
        .background {
            Image("DefaultBackground")
                .resizable()
                .scaledToFill()
                .overlay(
                    VStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 200)
                        
                        Spacer()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 200)
                    }
                )
                .ignoresSafeArea()
        }
        
        
        
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .dark

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    TimerSheet(user: LocalUser(nickname: "", mail: "", avatarImage: UIImage(systemName: "person.fill"), isAdmin: false), remainDays: 100, totalDays: 1000, progress: (100, 1000), image: Image("DefaultBackground"), isDMBStart: false, isDMBEnd: false)
}
