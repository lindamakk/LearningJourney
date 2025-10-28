// EquatableCalendarView.swift
// The code is corrected to pass the required 'viewModel' argument.

import SwiftUI
import Combine // Added for @StateObject stability

struct EquatableCalendarView<DateView: View, Value: Equatable>: View, Equatable {
    
    // 💡 FIX 1: Place property wrappers at the top level of the struct
    @StateObject private var viewModel = CalendarViewModel()
    
    // Static function remains correct for Equatable conformance
    static func == (
        lhs: EquatableCalendarView<DateView, Value>,
        rhs: EquatableCalendarView<DateView, Value>
    ) -> Bool {
        // The comparison logic here is correct, relying on 'value' and 'interval'
        lhs.interval == rhs.interval && lhs.value == rhs.value && lhs.showHeaders == rhs.showHeaders
    }
    
    // Stored properties
    let interval: DateInterval
    let value: Value
    let showHeaders: Bool
    let onHeaderAppear: (Date) -> Void
    let content: (Date) -> DateView
    
    // Initializer remains correct
    init(
        interval: DateInterval,
        value: Value,
        showHeaders: Bool = true,
        onHeaderAppear: @escaping (Date) -> Void = { _ in },
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.value = value
        self.showHeaders = showHeaders
        self.onHeaderAppear = onHeaderAppear
        self.content = content
    }
    
    var body: some View {
        CalendarView(
            interval: interval,
            showHeaders: showHeaders,
            onHeaderAppear: onHeaderAppear,
            // Pass content explicitly as the fourth argument
            content: { date in
                content(date)
            },
            // Pass viewModel explicitly as the fifth (and final) argument
            viewModel: viewModel
        )
    }
}
