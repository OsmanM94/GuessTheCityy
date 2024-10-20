//
//  Extensions.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import SwiftUI

extension View {
    func customTextField() -> some View {
        self
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .fontDesign(.rounded)
            .bold()
    }
}
