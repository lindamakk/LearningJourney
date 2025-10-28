//
//  ActivityViewModel.swift
//  LearningJourney
//
//  Created by Linda on 28/10/2025.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
final class ActivityViewModel: ObservableObject {
    
    // MARK: - Published UI State
    @Published var goalTitle: String = "Loading Goal..."
    @Published var daysLearned: Int = 0
    @Published var daysFreezed: Int = 0
    @Published var freezesUsedText: String = "0 out of 0 Freezes used"
    @Published var learnedToday: Bool = false
    @Published var freezeUsedToday: Bool = false
    
    // MARK: - Backing Data
    private(set) var streak: Streak?
    
    // MARK: - Load data from SwiftData
    func loadData(modelContext: ModelContext) {
        do {
            let request = FetchDescriptor<Streak>()
            if let fetched = try modelContext.fetch(request).first {
                update(with: fetched)
            } else {
                goalTitle = "Set a Goal"
            }
        } catch {
            print("Error loading streak:", error)
        }
    }
    
    
    // MARK: - Update computed values when streak changes
    func update(with streak: Streak?) {
        self.streak = streak
        
        guard let streak else {
            goalTitle = "Set a Goal"
            daysLearned = 0
            daysFreezed = 0
            freezesUsedText = "No Goal Active"
            learnedToday = false
            freezeUsedToday = false
            return
        }
        
        goalTitle = streak.goalTitle
        daysLearned = streak.days.filter { $0.status == .learned }.count
        daysFreezed = streak.days.filter { $0.status == .freezed }.count
        freezesUsedText = "\(streak.usedFreezes) out of \(streak.totalFreezes) Freezes used"
        
        // Reflect today's status
        let today = Calendar.current.startOfDay(for: Date())
        learnedToday = streak.days.contains { $0.status == .learned && Calendar.current.isDate($0.date, inSameDayAs: today) }
        freezeUsedToday = streak.days.contains { $0.status == .freezed && Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - Helpers
    private func day(for date: Date) -> Day? {
        streak?.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    // MARK: - User Actions (Mutations)
    
    func logLearned(for date: Date = Date(), modelContext: ModelContext) {
        guard let streak else { return }
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        if let index = streak.days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            streak.days[index].status = .learned
        } else {
            streak.days.append(Day(date: startOfDay, status: .learned))
        }
        
        streak.lastActionDate = startOfDay
        
        save(modelContext: modelContext)
    }
    
    func logFreezed(for date: Date = Date(), modelContext: ModelContext) {
        guard let streak else { return }
        guard streak.usedFreezes < streak.totalFreezes else {
            print("❌ Max freezes used.")
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        if let index = streak.days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            streak.days[index].status = .freezed
        } else {
            streak.days.append(Day(date: startOfDay, status: .freezed))
        }
        
        streak.usedFreezes += 1
        streak.lastActionDate = startOfDay
        
        save(modelContext: modelContext)
    }
    
    private func save(modelContext: ModelContext) {
        do {
            try modelContext.save()
            if let streak {
                update(with: streak) // refresh UI
            }
        } catch {
            print("Error saving streak:", error)
        }
    }
    
    // MARK: - Day Lookup
    func status(for date: Date) -> DayStatus? {
        let normalized = Calendar.current.startOfDay(for: date)
        return streak?.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: normalized) })?.status
    }
    
    
    func resetCurrentStreak(modelContext: ModelContext) {
        guard let streak = streak else { return }

        streak.days.removeAll()
        streak.usedFreezes = 0
        streak.lastActionDate = Calendar.current.startOfDay(for: Date())
        
        // Start today as pending again
        streak.days.append(Day(date: streak.lastActionDate, status: .pending))
        
        do {
            try modelContext.save()
            update(with: streak)
        } catch {
            print("Error resetting streak: \(error)")
        }
    }

}
