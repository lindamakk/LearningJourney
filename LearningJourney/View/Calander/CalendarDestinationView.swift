//
//  CalendarDestinationView.swift
//  learning_journey
//
//  Created by Linda on 27/10/2025.
//

import SwiftUI

// Assume all necessary Calendar and Date extensions and the
// EquatableCalendarView struct are in your project files.

struct DayContent: View {
    let date: Date
    @Environment(\.calendar) var calendar

    var body: some View {
        Text(String(calendar.component(.day, from: date)))
            .font(.caption)
            .frame(width: 32, height: 32)
            .background(calendar.isDateInToday(date) ? Color.accent : Color.clear) //is learned? else is freezed? eles no color
            .foregroundColor(calendar.isDateInToday(date) ? .white : .primary)
            .clipShape(Circle())
            .padding(.vertical, 4)
    }
}

struct CalendarDestinationView: View {
    @Environment(\.calendar) var calendar
    
    // 1. Required Equatable Value (to prevent unnecessary reloads)
    // We use a simple Int State variable here.
    @State private var calendarReloadTrigger: Int = 0
    
    // 2. Define the Date Interval (e.g., three years centered on today)
    private var threeYearInterval: DateInterval {
        let now = Date()
        let start = calendar.date(byAdding: .year, value: -1, to: now)!
        let end = calendar.date(byAdding: .year, value: 2, to: now)!
        return DateInterval(start: start, end: end)
    }

    var body: some View {
        ScrollView {
            // 3. Call the EquatableCalendarView (the wrapper)
            EquatableCalendarView(
                interval: threeYearInterval,
                value: calendarReloadTrigger, // Pass the trigger state
                showHeaders: true
            ) { date in
                // 4. Define the content for each day
                DayContent(date: date)
            }
            .padding()
        }
        .navigationTitle("All activities")
    }
}
