//
//  Activity.swift
//  learning_journey
//
//  Created by Linda on 22/10/2025.
//

import SwiftUI
import SwiftData

struct ActivityView: View {
    
    // Access stored streaks from SwiftData
    @Query private var streaks: [Streak]
    private var activeStreak: Streak? { streaks.first }
    
    // ViewModel handles logic, state, and persistence
    @StateObject private var viewModel = ActivityViewModel()
    
    // ModelContext for saving
    @Environment(\.modelContext) private var modelContext
    
    // Selected date for week view
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Header
                HStack {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    
                    NavigationLink(destination: CalendarDestinationView()) {
                        CustomGlassButton(
                            image: Image(systemName: "calendar"),
                            width: 48,
                            height: 48,
                            isNavigationLinkLabel: true
                        )
                    }
                    
                    NavigationLink(destination: EditGoal()) {
                        CustomGlassButton(
                            image: Image(systemName: "pencil.and.outline"),
                            width: 48,
                            height: 48,
                            isNavigationLinkLabel: true
                        )
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Goal + Week Overview
                VStack {
                    CustomWeekDatePicker(
                        selectedDate: $selectedDate,
                        viewModel: viewModel
                    )
                    
                    Divider()
                    
                    HStack {
//                     Text("Learning ")
                        Text(viewModel.goalTitle)
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    
                    Spacer().frame(height: 12)
                    
                    HStack {
                        CustomStreakContainer(
                            streak: viewModel.daysLearned,
                            isLearn: true
                        )
                        Spacer()
                        CustomStreakContainer(
                            streak: viewModel.daysFreezed,
                            isLearn: false
                        )
                    }
                }
                .padding()
                
                Spacer().frame(height: 24)
                
                // MARK: - Learn Button
                CustomGlassButton(
                    title: "Start learning",
                    isActive:  !viewModel.learnedToday ||  !viewModel.freezeUsedToday,
                    width: 300,
                    height: 300,
                    isDisabled: viewModel.learnedToday || viewModel.freezeUsedToday,
                    action: {
                        viewModel.logLearned(modelContext: modelContext)
                    }
                )
                
                Spacer().frame(height: 40)
                
                // MARK: - Freeze Button
                CustomGlassButton(
                    title: "Log as Freezed",
                    isSecondary: true,
                    isActive: !viewModel.learnedToday ||  !viewModel.freezeUsedToday,
                    width: 300,
                    isDisabled: viewModel.learnedToday || viewModel.freezeUsedToday,
                    action: {
                        viewModel.logFreezed(modelContext: modelContext)
                    }
                )
                
                Spacer().frame(height: 12)
                
                // MARK: - Info Text
                Text(viewModel.freezesUsedText)
                    .font(.body)
                    .foregroundStyle(Color(.secondaryLabel))
                
                Spacer()
            }
            .onAppear {
                // Load data when view appears
                if activeStreak != nil {
                    viewModel.update(with: activeStreak)
                } else {
                    viewModel.loadData(modelContext: modelContext)
                }
            }
            .onChange(of: activeStreak) { _, newValue in
                viewModel.update(with: newValue)
            }
        }
    }
}



// MARK: - Custom Week Date Picker
struct CustomWeekDatePicker: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: ActivityViewModel
    @State private var weekStartDate: Date = Calendar.current.startOfWeek(for: Date())
    
    var body: some View {
        VStack {
            // Header with week range
            HStack {
                Text(weekRangeText)
                    .font(.headline)
                Spacer()
                Button(action: { changeWeek(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer().frame(width: 28)
                Button(action: { changeWeek(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            // Days row
            HStack(spacing: 12) {
                ForEach(daysInWeek(startingFrom: weekStartDate), id: \.self) { date in
                    dayButton(for: date)
                }
            }
        }
    }
    
    // MARK: - Day Button
    func dayButton(for date: Date) -> some View {
        let isToday = Calendar.current.isDateInToday(date)
        let status = viewModel.status(for: date)
        
        let fillColor: Color
        switch status {
        case .learned:
            fillColor = .orange.opacity(0.3)
        case .freezed:
            fillColor = .blue.opacity(0.3)
        case .skipped:
            fillColor = .gray.opacity(0.2)
        default:
            fillColor = isToday ? .accentColor.opacity(0.4) : .clear
        }
        
        return VStack(spacing: 4) {
            Text(shortDay(from: date))
                .font(.callout)
                .bold()
                .foregroundColor(.gray)
            
            Text(dayNumber(from: date))
                .font(.title2)
                .foregroundColor(isToday ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(Circle().fill(fillColor))
        }
        .onTapGesture {
            selectedDate = date
        }
    }
    
    // MARK: - Helpers
    func shortDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func changeWeek(by offset: Int) {
        if let newStart = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: weekStartDate) {
            weekStartDate = newStart
        }
    }
    
    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: weekStartDate)!
        return "\(formatter.string(from: weekStartDate)) - \(formatter.string(from: endOfWeek))"
    }
    
    private func daysInWeek(startingFrom date: Date) -> [Date] {
        (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: date)
        }
    }
}

// MARK: - Calendar Extension
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: Streak.self, inMemory: true)
}
