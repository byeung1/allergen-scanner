//
//  Allergen_ScannerApp.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-14.
//

import SwiftUI

// The entry point
@main
struct Allergen_ScannerApp: App {
    var body: some Scene {
        // Supplies the root for this window
        // The HomeView is the first thing the user sees when they open up the application
        WindowGroup {
            HomeView()
        }
    }
}

