//
//  DMBWidget.swift
//  DMBWidget
//
//  Created by Арсен Хачатрян on 08.02.2025.
//

import WidgetKit
import SwiftUI

struct TimerEntry: TimelineEntry {
    let date: Date
    let remainDays: Int
    let allDays: Int
}

struct TimerProvider: TimelineProvider {
    let userDefaults = UserDefaultsManager.shared

    func placeholder(in context: Context) -> TimerEntry {
        TimerEntry(date: Date(), remainDays: 10, allDays: 100)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        let entry = loadTimerData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        var entries: [TimerEntry] = []
        
        let currentDate = Date()
        for i in 0..<96 { // Обновление каждые 15 минут
            let entryDate = Calendar.current.date(byAdding: .minute, value: i * 15, to: currentDate)!
            let entry = loadTimerData(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func loadTimerData(date: Date = Date()) -> TimerEntry {
        let remainDays = getRemainDays() ?? 0
        let allDays = getAllDays() ?? 0
        return TimerEntry(date: date, remainDays: remainDays, allDays: allDays)
    }
    
    func getRemainDays() -> Int? {
        let sec = Int((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince(Date.now))
        return sec/60/60/24
    }
    
    func getAllDays() -> Int? {
        let sec = Int((userDefaults.date(forKey: .endDate) ?? Date.now).timeIntervalSince(userDefaults.date(forKey: .startDate) ?? Date.now))
        return sec/60/60/24
    }
}

struct DaysLeftProvider: TimelineProvider {
    func placeholder(in context: Context) -> DaysLeftEntry {
        DaysLeftEntry(date: Date(), daysLeft: 300)
    }

    func getSnapshot(in context: Context, completion: @escaping (DaysLeftEntry) -> Void) {
        let entry = DaysLeftEntry(date: Date(), daysLeft: 300)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DaysLeftEntry>) -> Void) {
        let entry = DaysLeftEntry(date: Date(), daysLeft: 300)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct CurvedCapsule: Shape {
    
    let procentOfVisible: Double
    let lineWidth: CGFloat
    
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        if procentOfVisible != 0 {
            let radius = rect.width / 2
            let startAngle = Angle(degrees: 10)
            let endAngle = Angle(degrees: (80 * procentOfVisible < 10) ? 10 : (80 * procentOfVisible)) // Было 90°, уменьшили для пробела
            
            path.addArc(
                center: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            
        }
        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

// 365 20

struct CircularCapsulesView: View {
    
    var widthHeight:CGFloat = 250
    
    let capsuleCount = 4
    let spacingAngle: Double = 10
    
    let procent = 0.5
    var procents:[Double] = [1, 1, 0.5, 0]
    
    init(widthHeight: CGFloat = 120,allDays: Double, remainDays: Double) {
        if remainDays > allDays {
            procents = [0,0,0,0]
        } else if allDays < 0 || remainDays < 0 {
            procents = [1, 1, 1, 1]
        } else {
            var a:Double = (1 - remainDays / allDays) / 0.25
            
            for i in 0 ..< 4 {
                if a < 1 {
                    procents[i] = a
                    a = 0
                } else {
                    procents[i] = 1
                    a -= 1
                }
            }
        }
        
        self.widthHeight = widthHeight
        
        
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<capsuleCount, id: \.self) { i in
                
                CurvedCapsule(procentOfVisible: 1, lineWidth: widthHeight == 120 ? 9 : 16)
                    .foregroundStyle(.white)
                    .opacity(0.2)
                    .frame(width: widthHeight, height: widthHeight)
                    .rotationEffect(.degrees(Double(i) * (360 / Double(capsuleCount))))
                
            }
            ForEach(0..<capsuleCount, id: \.self) { i in
                
                CurvedCapsule(procentOfVisible: procents[i], lineWidth: widthHeight == 120 ? 9 : 16)
                    .foregroundStyle(.white)
                    .shadow(color: .white,radius: 4)
                    .frame(width: widthHeight, height: widthHeight)
                    .rotationEffect(.degrees(Double(i) * (360 / Double(capsuleCount))))
                
            }
            
        }
        .rotationEffect(.degrees(89))
    }
}

struct DashedSemiCircle: View {
    let dashCount: Int = 4// Количество пунктиров
    let strokeWidth: CGFloat = 12 // Толщина линий
    
    var widthHeight:CGFloat = 250
    
    var procents: [Double] = [1, 1, 0.1, 0]
    
    init(allDays: Double, remainDays: Double) {
        
        if remainDays > allDays {
            procents = [0,0,0,0]
        } else if allDays < 0 || remainDays < 0 {
            procents = [1, 1, 1, 1]
        } else {
            var a:Double = (1 - remainDays / allDays) / 0.25
            
            for i in 0 ..< 4 {
                if a < 1 {
                    procents[i] = a
                    a = 0
                } else {
                    procents[i] = 1
                    a -= 1
                }
            }
        }
                
        
    }
    
    var body: some View {
        
        
        
        ZStack {
            
            ForEach(0..<dashCount, id: \.self) { i in
                let start = Double(i) / Double(dashCount) * 0.5 // Начало каждого сегмента
                let end = start + 0.5 / Double(dashCount) * 0.8 // Длина пунктиров (уменьшаем 0.8 для пробелов)
                
                    Circle()
                        .trim(from: start, to: end)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                        .frame(width: widthHeight, height: widthHeight)
                        .rotationEffect(.degrees(184)) // Чтобы начало было слева
                        .opacity(0.2)
                        .padding()
            }
            ForEach(0..<dashCount, id: \.self) { i in
                let start = Double(i) / Double(dashCount) * 0.5 // Начало каждого сегмента
                let end = start + 0.5 / Double(dashCount) * 0.8 // Длина пунктиров (уменьшаем 0.8 для пробелов)
                if procents[i] == 0 || procents[i] == 1 {
                    Circle()
                        .trim(from: start, to: end)
                        .trim(from: 1 - procents[i])
                        .stroke(Color.white, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                        .shadow(color: .white,radius: 4)
                        .frame(width: widthHeight, height: widthHeight)
                        .rotationEffect(.degrees(184)) // Чтобы начало было слева
                        .padding()
                } else {
                    Circle()
                        .trim(from: start, to: end)
                        .trim(from: 0,to: procents[i])
                        .stroke(Color.white, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                        .shadow(color: .white,radius: 4)
                        .frame(width: widthHeight, height: widthHeight)
                        .rotationEffect(.degrees(184)) // Чтобы начало было слева
                        .padding()
                }
            }
            
        }
        .padding(.bottom, -105)
    }
}

struct DaysLeftEntry: TimelineEntry {
    let date: Date
    let daysLeft: Int
}

struct DaysLeftWidgetEntryView: View {
    var entry: TimerEntry
    
    @State var seconds = 750
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default).autoconnect()
    
    
    @Environment(\.widgetFamily) var family
    
    
    
    var body: some View {
        ZStack {
            switch family {
            case .systemSmall: ZStack {
                Image("widgetBackground")
                    .resizable()
                    .scaledToFill() // или .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .padding(-20)
                
                VStack(spacing: 4) {
                    Text("ОСТАЛОСЬ")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        HStack(alignment: .bottom, spacing: 1) {
//                            Text("\(entry.remainDays < 0 ? 0 : entry.remainDays)")
//                                .font(.system(size: 25, weight: .heavy, design: .rounded))
//                                .foregroundColor(.white)
                            Text("\(entry.remainDays < 0 ? 0 : entry.remainDays)")
                                .font(.system(size: 25, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("ДНЕЙ")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom, 4)
                        }
                    
                }
                
                CircularCapsulesView(allDays: Double(entry.allDays), remainDays: Double(entry.remainDays))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(-8)
                    .padding(.horizontal, -4)
            }
            case .systemMedium:
                ZStack {
                    Image("widgetBackground")
                        .resizable()
                        .scaledToFill() // или .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .padding(-20)
                    
                    VStack(spacing: 4) {
                        Text("ОСТАЛОСЬ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            HStack(alignment: .bottom, spacing: 1) {
                                Text("\(entry.remainDays < 0 ? 0 : entry.remainDays)")                                    .font(.system(size: 25+8, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("ДНЕЙ")
                                    .font(.system(size: 12+8, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                            }
                        
//                        if true {
//                            HStack(alignment: .bottom, spacing: 1) {
//                                Text("\(300)")
//                                    .font(.system(size: 25+15, weight: .heavy, design: .rounded))
//                                    .foregroundColor(.white)
//                                
//                                Text("ДНЕЙ")
//                                    .font(.system(size: 12+8, weight: .bold))
//                                    .foregroundColor(.white)
//                                    .padding(.bottom, 4)
//                            }
//                        }
                        
                    }
                    .padding(.bottom, -30)
                    
                    DashedSemiCircle(allDays: Double(entry.allDays), remainDays: Double(entry.remainDays))
                }
                .padding(.bottom, -30)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(-8)
                        .padding(.horizontal, -4)
                        .padding(.vertical, 82)
                }
            case .systemLarge:
                ZStack {
                    Image("widgetBackground")
                        .resizable()
                        .scaledToFill() // или .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .padding(-20)
                    
                    VStack(spacing: 4) {
                        Text("ОСТАЛОСЬ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            HStack(alignment: .bottom, spacing: 1) {
                                Text("\(entry.remainDays < 0 ? 0 : entry.remainDays)")                                    .font(.system(size: 25+8, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("ДНЕЙ")
                                    .font(.system(size: 12+8, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                            }
                        
                    }
                    
                    CircularCapsulesView(allDays: Double(entry.allDays), remainDays: Double(entry.remainDays))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(-8)
                        .padding(.horizontal, -4)
                }
            case .systemExtraLarge:
                ZStack {
                    Image("widgetBackground")
                        .resizable()
                        .scaledToFill() // или .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .padding(-20)
                    
                    VStack(spacing: 4) {
                        Text("ОСТАЛОСЬ")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            HStack(alignment: .bottom, spacing: 1) {
                                Text("\(entry.remainDays)")                                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("ДНЕЙ")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                            }
                        
                        
                    }
                    CircularCapsulesView(allDays: Double(entry.allDays), remainDays: Double(entry.remainDays))
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(-8)
                        .padding(.horizontal, -4)
                }
            default:
                ZStack {
                    Image("widgetBackground")
                        .resizable()
                        .scaledToFill() // или .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .padding(-20)
                    
                    VStack(spacing: 4) {
                        Text("ОСТАЛОСЬ")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            
                            HStack(alignment: .bottom, spacing: 1) {
                                Text("\(entry.remainDays < 0 ? 0 : entry.remainDays)")                                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("ДНЕЙ")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                            }
                        
                        
                    }
                    
                    CircularCapsulesView(allDays: Double(entry.allDays), remainDays: Double(entry.remainDays))
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(-8)
                        .padding(.horizontal, -4)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
//            LinearGradient(colors: [.black, Color(red: 180/255, green: 0, blue: 0),Color(red: 180/255, green: 0, blue: 0),.black], startPoint: .topLeading, endPoint: .bottomTrailing)
//                .padding(-100)
            
        )
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
        .background {
            if #available(iOS 17, *) {} else {
                Color(.systemBackground)
            }
        }
       
    }
    
    
}


struct DaysLeftWidget_Previews: PreviewProvider {
    static var previews: some View {
        DaysLeftWidgetEntryView(entry: TimerEntry(date: Date.now, remainDays: 299, allDays: 400))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
