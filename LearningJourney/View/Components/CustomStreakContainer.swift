//
//  CustomStreakContainer.swift
//  LearningJourney
//
//  Created by Linda on 28/10/2025.
//

import SwiftUI

// MARK: - Custom Streak Container
struct CustomStreakContainer: View {
    var streak: Int
    var isLearn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isLearn ? "flame.fill" : "snowflake")
                .foregroundColor(isLearn ? .orange : .blue)
                .font(.system(size: 24))
                .padding(4)
            
            VStack(alignment: .leading) {
                Text("\(streak)")
                    .font(.title)
                Text(isLearn ? "Days Learned" : "Days Frozen")
                    .font(.caption)
            }
            Spacer()
        }
        .padding(16)
        .frame(width: 175, height: 80)
        .background(isLearn ? Color.orange.opacity(0.1) : Color.blue.opacity(0.1))
        .clipShape(Capsule())
    }
}
