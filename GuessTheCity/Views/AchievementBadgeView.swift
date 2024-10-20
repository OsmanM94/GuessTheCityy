//
//  AchievementBadgeView.swift
//  GuessTheCity
//
//  Created by asia on 08.10.2024.
//

import SwiftUI
import SwiftData

struct AchievementBadgesView: View {
    @Query private var achievements: [Achievement]
    @Environment(\.modelContext) private var modelContext
    @Environment(AchievementViewModel.self) private var achievementViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(achievements, id: \.id) { achievement in
                    AchievementRow(achievement: achievement)
                }
            }
            .overlay {
                if achievements.isEmpty {
                    ContentUnavailableView("No achievements unlocked", systemImage: "tray.fill")
                }
            }
            .navigationTitle("Achievements")
        }
        .onAppear {
            createInitialAchievementsIfNeeded()
            checkForNewAchievements()
        }
    }
    
    private func createInitialAchievementsIfNeeded() {
        guard achievements.isEmpty else { return }
        
        let initialAchievements = [
            Achievement(name: "Streak Master", descriptionText: "Guess 5 locations in a row", requiredCount: 5),
            Achievement(name: "Conqueror", descriptionText: "Guess 10 locations in a row", requiredCount: 10),
            Achievement(name: "Century Club", descriptionText: "Correctly guess a total of 100 locations", requiredCount: 100)
        ]
        
        initialAchievements.forEach { modelContext.insert($0) }
    }
    
    private func checkForNewAchievements() {
        for achievement in achievements where !achievement.isUnlocked {
            if achievementViewModel.currentStreak >= achievement.requiredCount {
                achievement.isUnlocked = true
                achievement.unlockedDate = Date()
                achievementViewModel.showAchievement()
            }
        }
        try? modelContext.save()
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                .foregroundStyle(achievement.isUnlocked ? .yellow : .gray)
            VStack(alignment: .leading) {
                Text(achievement.name)
                    .font(.headline)
                Text(achievement.descriptionText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if achievement.isUnlocked, let date = achievement.unlockedDate {
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    AchievementBadgesView()
        .environment(AchievementViewModel())
}
