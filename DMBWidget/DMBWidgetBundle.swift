//
//  DMBWidgetBundle.swift
//  DMBWidget
//
//  Created by Арсен Хачатрян on 08.02.2025.
//

import WidgetKit
import SwiftUI

@main
struct DaysLeftWidget: Widget {
    let kind: String = "TimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TimerProvider()) { entry in
            DaysLeftWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Дни до цели")
        .description("Отслеживание оставшихся дней")
        .supportedFamilies([.systemSmall, .systemMedium])
         // Выберите подходящие размеры
    }
}
