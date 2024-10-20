//
//  Profile.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import Foundation
import SwiftData

@Model
class Statistics {
    var highestScore: Int
    var totalQuestionsAnswered: Int
    var totalCorrect: Int
    var longestStreak: Int
    var currentStreak: Int
    
    init(highestScore: Int = 0, totalQuestionsAnswered: Int = 0, totalCorrect: Int = 0, longestStreak: Int = 0, currentStreak: Int = 0) {
        self.highestScore = highestScore
        self.totalQuestionsAnswered = totalQuestionsAnswered
        self.totalCorrect = totalCorrect
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
    }
    
    var percentageCorrect: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalQuestionsAnswered) * 100
    }
    
    var percentageIncorrect: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return 100 - percentageCorrect
    }
}
