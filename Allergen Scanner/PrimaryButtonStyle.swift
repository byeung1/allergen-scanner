//
//  PrimaryButtonStyle.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-15.
//


import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color

    // aesthetics for various buttons
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
