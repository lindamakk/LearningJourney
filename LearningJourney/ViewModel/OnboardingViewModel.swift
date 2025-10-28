//
//  OnboardingViewModel.swift
//  LearningJourney
//
//  Created by Linda on 27/10/2025.
//

import SwiftUI
import Combine
import SwiftData

class OnboardingViewModel: ObservableObject {
    @Published var goalTitle: String = ""
    
    // ⚠️ تم التعديل: استخدام 'Duration' بدلاً من 'DurationViewModel.Duration'
    @Published var selectedDuration: Duration = .week
    
    // ... (selectedDurationInDays و initialFreezes)
    private var selectedDurationInDays: Int {
        switch selectedDuration {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
    
    private var initialFreezes: Int {
        switch selectedDuration {
        case .week: return 2
        case .month: return 8
        case .year: return 50
        }
    }
    
    // 🆕 تم الإضافة: دالة لتحديث المدة الزمنية لتجنب الخطأ
    func selectDuration(_ duration: Duration) {
        self.selectedDuration = duration
    }

    // 3. SAVING FUNCTION (Requires a ModelContext from the View)
    func saveStreak(modelContext: ModelContext) {
        // Validation: Ensure the user entered a goal title
        guard !goalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Goal title is empty. Cannot save.")
            return
        }
        
        // A. Create the new Streak object
        let newStreak = Streak(
            goalTitle: goalTitle,
            streakDurationDays: selectedDurationInDays,
            totalFreezes: initialFreezes
        )
        
        // B. Insert the object into SwiftData
        modelContext.insert(newStreak)
        
        // C. Save the context (optional, often done automatically, but explicit is safer)
        do {
            try modelContext.save()
            print("Successfully saved new streak: \(goalTitle) for \(selectedDurationInDays) days.")
            // You would typically navigate the user away from the onboarding view here
        } catch {
            print("Error saving streak: \(error.localizedDescription)")
        }
    }
}
