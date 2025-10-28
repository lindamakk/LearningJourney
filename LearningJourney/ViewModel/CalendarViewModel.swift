//
//  CalendarViewModel.swift
//  learning_journey
//
//  Created by Linda on 27/10/2025.
//

import SwiftUI
import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var months: [Date] = []
    @Published var days: [Date: [Date]] = [:]
    
    // The calendar logic is stored here, making it testable and reusable.
    private let calendar = Calendar.current
    
    func loadCalendar(for interval: DateInterval) {
        // 1. Calculate the months
        months = calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
        
        // 2. Calculate the days for each month
        days = months.reduce(into: [:]) { current, month in
            guard
                let monthInterval = calendar.dateInterval(of: .month, for: month),
                let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
                let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
            else { return }
            
            current[month] = calendar.generateDates(
                inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            )
        }
    }
    
    // 1. Get the short, localized weekday symbols (S, M, T, W, T, F, S)
        func getWeekdaySymbols() -> [String] {
            return calendar.shortWeekdaySymbols
        }
        
        // 2. Helper to get the short day name from a date
        func shortDay(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter.string(from: date)
        }

        // 3. Helper to get the day number from a date
        func dayNumber(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter.string(from: date)
        }
}
