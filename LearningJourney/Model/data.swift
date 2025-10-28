//
//  data.swift
//  learning_journey
//
//  Created by Linda on 27/10/2025.
//

import Foundation
import SwiftData

// Convert the Duration enum to Int for clean storage
enum DurationKey: Int, CaseIterable, Codable {
    case week = 7
    case month = 30
    case year = 365
}

// DayStatus and Day remain structs/enums, but the Streak is the main @Model

@Model
final class Streak {
    @Attribute(.unique) var id: UUID
    var goalTitle: String
    var streakDurationDays: Int
    var startDate: Date
    var totalFreezes: Int
    var usedFreezes: Int
    var isDone: Bool
    var lastActionDate: Date
    var days: [Day]
    
    // MARK: - Custom Initializer (Fixes Ambiguity)

    // IMPORTANT: Keep this initializer non-failable and match the parameter labels
    // you are using in your ViewModel.
    init(goalTitle: String, streakDurationDays: Int, totalFreezes: Int) {
        self.id = UUID()
        self.goalTitle = goalTitle
        self.streakDurationDays = streakDurationDays
        self.totalFreezes = totalFreezes
        self.usedFreezes = 0
        self.isDone = false
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        self.startDate = startOfToday
        self.lastActionDate = startOfToday
        
        // Initialize with the first Day object
        self.days = [Day(date: startOfToday, status: .pending)]
    }
}

struct Day: Identifiable, Codable {
    // Unique identifier for use in SwiftUI lists/updates (e.g., UUID() upon creation)
    let id = UUID()
    
    // The date this day record represents (e.g., "2025-10-27 00:00:00")
    let date: Date
    
    // The action taken on this day (default is pending)
    var status: DayStatus = .pending
}

enum DayStatus: String, Codable {
    case pending // Day has not yet been addressed (default for current/future day)
    case learned // User successfully completed the goal
    case freezed // User used a freeze to keep the streak alive
    case skipped // User took no action and lost the streak (or potential loss if today)
}

enum Duration: String, CaseIterable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
