//
//  Achivement.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import Foundation
import SwiftData

@Model
final class Achievement {
    var id: UUID
    var name: String
    var descriptionText: String
    var requiredCount: Int
    var isUnlocked: Bool
    var unlockedDate: Date?
    var hasBeenShown: Bool

    init(id: UUID = UUID(), name: String, descriptionText: String, requiredCount: Int, isUnlocked: Bool = false, unlockedDate: Date? = nil, hasBeenShown: Bool = false) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.requiredCount = requiredCount
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
        self.hasBeenShown = hasBeenShown
    }
}
