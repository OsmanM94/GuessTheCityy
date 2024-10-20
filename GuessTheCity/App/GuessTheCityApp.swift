//
//  GuessTheCityApp.swift
//  GuessTheCity
//
//  Created by asia on 05/10/2024.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct GuessTheCityApp: App {
    @State private var achivementViewModel = AchievementViewModel()
    
    var body: some Scene {
        WindowGroup {
            Tab()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                .environment(achivementViewModel)
        }
        .modelContainer(for: [Achievement.self, Statistics.self])

    }
}
