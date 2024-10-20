//
//  AchivementView.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import SwiftUI
import SwiftData

struct AchievementView: View {
    @Environment(AchievementViewModel.self) private var achievementViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Query private var achievements: [Achievement]
    
    var body: some View {
        VStack {
            Spacer()
            if achievementViewModel.showingAchievement,
               let unlockedAchievement = achievements.first(where: { $0.isUnlocked && !$0.hasBeenShown }) {
                achievementCard(for: unlockedAchievement)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                    .onAppear {
                        markAchievementAsShown(unlockedAchievement)
                    }
            }
        }
        .padding(.bottom)
    }
    
    private func achievementCard(for achievement: Achievement) -> some View {
        HStack {
            Image(systemName: "trophy.fill")
                .foregroundStyle(.yellow)
            VStack(alignment: .leading) {
                Text("Achievement Unlocked!")
                    .font(.headline)
                Text(achievement.name)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func markAchievementAsShown(_ achievement: Achievement) {
        achievement.hasBeenShown = true
        try? modelContext.save()
    }
}

#Preview {
    AchievementView()
        .modelContainer(for: Achievement.self, inMemory: true)
        .environment(AchievementViewModel())
}
