// CalanderView.swift

import Foundation
import SwiftUI
import Combine // Added for robustness, though often implicit via SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    // Retain these inputs needed for the ViewModel call
    let interval: DateInterval
    let showHeaders: Bool
    let onHeaderAppear: (Date) -> Void
    let content: (Date) -> DateView
    
    // The view receives the data source
    @ObservedObject var viewModel: CalendarViewModel

    @Environment(\.sizeCategory) private var contentSize
    @Environment(\.calendar) private var calendar
    
    // The columns property remains correct for the grid layout
    private var columns: [GridItem] {
        let spacing: CGFloat = contentSize.isAccessibilityCategory ? 2 : 8
        return Array(repeating: GridItem(spacing: spacing), count: 7)
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            // Use the ViewModel's published 'months' property
            ForEach(viewModel.months, id: \.self) { month in
                Section(header: header(for: month)) {
                    // Use the ViewModel's published 'days' dictionary
                    ForEach(viewModel.days[month, default: []], id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date).id(date)
                        } else {
                            // Ensures calendar layout integrity by hiding dates outside the current month's scope
                            content(date).hidden()
                        }
                    }
                }
            }
        }
        .onAppear {
            // Trigger the ViewModel to calculate the data when the view loads
            viewModel.loadCalendar(for: interval)
        }
    }

    private func header(for month: Date) -> some View {
        Group {
            if showHeaders {
                VStack(alignment: .leading) {
                    HStack {
                        // Uses the shared DateFormatter (from your Model/Extensions)
                        Text(DateFormatter.monthAndYear.string(from: month))
                            .font(.title2)
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer(minLength: 12)
                    // Fetches the data (weekday symbols) from the ViewModel
                    WeekdayHeaderView(weekdaySymbols: viewModel.getWeekdaySymbols())
                }
                .padding(.vertical, 8)
            }
        }
        .onAppear { onHeaderAppear(month) }
    }
}
