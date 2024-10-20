//
//  Tab.swift
//  GuessTheCity
//
//  Created by asia on 05/10/2024.
//

import SwiftUI


struct Tab: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Guess", systemImage: "questionmark.circle.fill")
                }
                .tag(0)
            
            AchievementBadgesView()
                .tabItem {
                    Label("Achievements", systemImage: "trophy.fill")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    Tab()
        .environment(AchievementViewModel())
}
