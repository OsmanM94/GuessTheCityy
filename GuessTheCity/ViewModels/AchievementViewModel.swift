//
//  Achivement.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import Foundation
import SwiftData

@Observable
final class AchievementViewModel {
    var showingAchievement: Bool = false
    var currentStreak: Int = 0
    
    func resetStreak() {
        currentStreak = 0
    }
    
    func incrementStreak() {
        currentStreak += 1
    }
    
    func updateAchievements(correct: Bool) {
        if correct {
            incrementStreak()
        } else {
            resetStreak()
        }
    }
    
    func showAchievement() {
        showingAchievement = true
        hideAchievementAfterDelay()
    }
    
    private func hideAchievementAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.showingAchievement = false
        }
    }
}
