//
//  WeekdayHeaderView.swift
//  learning_journey
//
//  Created by Linda on 27/10/2025.
//

import SwiftUI

struct WeekdayHeaderView: View {
    // Pass the required symbols from the ViewModel
    let weekdaySymbols: [String]
    
    var body: some View {
        HStack(spacing: 8) { // Use spacing that matches your grid columns
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.caption)
                    .bold() // Keeping it bold for clarity
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity) // Ensures even spacing
            }
        }
        .padding(.horizontal, 8) // Small horizontal padding to match grid edge
        .padding(.bottom, 5)
    }
}
