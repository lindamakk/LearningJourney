//
//  DurationViewModel.swift
//  LearningJourney
//
//  Created by Linda on 27/10/2025.
//

import SwiftUI
import Combine

class DurationViewModel: ObservableObject {
    // 1. Published property to hold the selected duration.
    @Published var selectedDuration: Duration = .week

    // Define an enum for clarity and type safety
    enum Duration: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    // ... inside DurationViewModel
        
        // 2. The function to "toggle" and save the selected duration.
        func selectDuration(_ duration: Duration) {
            // Toggling logic: simply update the published property
            self.selectedDuration = duration
            
        }
    }

