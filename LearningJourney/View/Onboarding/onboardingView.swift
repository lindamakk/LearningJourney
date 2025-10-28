//
// OnboardingView.swift
// learning_journey
//
// Created by Linda on 16/10/2025.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    
    // 1. Inject the ViewModel
    @StateObject private var viewModel = OnboardingViewModel()
    
    // 2. Get the SwiftData Model Context
    @Environment(\.modelContext) private var modelContext
    
    @State private var navigateToActivity = false
    
    var body: some View {
        // FIX: The NavigationStack should wrap the entire content or be placed at a higher level.
        // Assuming this is the starting view for navigation, wrap the content here.
        NavigationStack { // <--- Added NavigationStack here
            VStack(alignment: .leading) {
                GlassEffectContainer(spacing: 0) {
                    HStack {
                        Spacer()
                        Image(systemName: "flame.fill")
                            .foregroundColor(Color(.orange))
                            .font(.system(size: 36))
                            .frame(width: 90, height: 90)
                            .padding()
                        
                            .glassEffect()
                        Spacer()
                        
                    }
                }.background(Color.brown.opacity(0.2))
                    .clipShape(Circle()) // 1. Clips the GlassEffectContainer content into a circle
                // .overlay(
                // Circle()
                // .stroke(Color.orange, lineWidth: 0.5)
                // )
                Spacer().frame(height: 50)
                Text("Hello Learner")
                    .font(.largeTitle)
                    .bold()
                
                Text("This app will help you learn everyday!")
                    .font(.title3)
                    .foregroundStyle(Color(.secondaryLabel))
                Spacer().frame(height: 30)
                
                // Goal Input Field
                Text("I want to learn")
                    .font(.title2)
                
                // 3. Bind TextField to viewModel.goalTitle
                TextField("e.g. Swift", text: $viewModel.goalTitle)
                    .autocorrectionDisabled()
                Divider()
                
                Spacer().frame(height: 24)
                
                Text("I want to learn it in a ")
                    .font(.title2)
                
                // 4. Pass the ViewModel's state down to the sub-view
                DurationSelectionView(viewModel: viewModel)
                
                Spacer()
                
                HStack {
                    Spacer()
                    // 5. Connect the action button to the save function
                    // FIX: Removed the nested NavigationStack here
                    CustomGlassButton(title: "Start learning", isActive:true, width: 182, action: {
                        viewModel.saveStreak(modelContext: modelContext)
                        print("viewModel goalTitle is: \(viewModel.goalTitle)") // Better print statement
                        navigateToActivity = true
                    })
                    Spacer()
                }
            }
            .padding(20)
            // FIX: Moved navigationDestination to the root of the NavigationStack content
            .navigationDestination(isPresented: $navigateToActivity) {
                ActivityView()
            }
        } // <--- Closed NavigationStack here
    }
}

// ---

struct DurationSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let durations: [Duration] = Duration.allCases
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(durations, id: \.self) { duration in
                CustomGlassButton(
                    title: duration.rawValue,
                    isActive: viewModel.selectedDuration == duration,
                    action: {
                        
                        viewModel.selectDuration(duration)
                    }
                )
            }
        }
    }
}

// ---

#Preview {
    OnboardingView()
    // Streak هو الـ Model الوحيد الذي نعرفه الآن
        .modelContainer(for: Streak.self, inMemory: true)
}
