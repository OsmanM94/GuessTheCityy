//
//  ProfileView.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var statistics: [Statistics]
    @State private var showingResetAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Scores")) {
                    StatRow(title: "Highest Score", value: "\(statistics.first?.highestScore ?? 0)")
                    StatRow(title: "Current Streak", value: "\(statistics.first?.currentStreak ?? 0)")
                    StatRow(title: "Longest Streak", value: "\(statistics.first?.longestStreak ?? 0)")
                }
                
                Section(header: Text("Questions")) {
                    StatRow(title: "Total Answered", value: "\(statistics.first?.totalQuestionsAnswered ?? 0)")
                    StatRow(title: "Total Correct", value: "\(statistics.first?.totalCorrect ?? 0)")
                }
                
                Section(header: Text("Accuracy")) {
                    StatRow(title: "Correct", value: String(format: "%.1f%%", statistics.first?.percentageCorrect ?? 0))
                    StatRow(title: "Incorrect", value: String(format: "%.1f%%", statistics.first?.percentageIncorrect ?? 0))
                }
                
                Section {
                    Button("Reset Statistics") {
                        showingResetAlert = true
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Statistics")
        }
        .alert("Reset Statistics", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetStatistics()
            }
        } message: {
            Text("Are you sure you want to reset all your statistics?")
        }
        .onAppear {
            if statistics.isEmpty {
                let newStats = Statistics()
                modelContext.insert(newStats)
            }
        }
    }
    
    private func resetStatistics() {
        if let stats = statistics.first {
            stats.highestScore = 0
            stats.totalQuestionsAnswered = 0
            stats.totalCorrect = 0
            stats.longestStreak = 0
            stats.currentStreak = 0
            try? modelContext.save()
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: Statistics.self, inMemory: true)
}
