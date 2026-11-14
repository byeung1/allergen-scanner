//
//  ProfileView.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-14.
//

import SwiftUI

struct ProfileView: View {
    // Allocates memory to "selectedAllergens" to ensure the data is saved
    // even after force closing the application
    @AppStorage("selectedAllergens") var selectedAllergensData: Data = Data()
    @State private var selectedAllergens: Set<Allergen> = []

    var body: some View {
        List {
            ForEach(knownAllergens) { allergen in
                // When an item is tapped, remove it if it is already in the list, and add it
                // if it was not
                Button(action: {
                    if selectedAllergens.contains(allergen) {
                        selectedAllergens.remove(allergen)
                    } else {
                        selectedAllergens.insert(allergen)
                    }
                    saveSelection()
                }) {
                    HStack {
                        Text(allergen.name)
                        Spacer()
                        if selectedAllergens.contains(allergen) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }

            // Button to clear all saved allergens
            Section {
                Button("Clear Saved Allergens") {
                    selectedAllergensData = Data()
                    selectedAllergens = []
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Select Allergens")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadSelection()
        }
    }

    // helper function to save the list any time it is modified
    private func saveSelection() {
        if let data = try? JSONEncoder().encode(Array(selectedAllergens)) {
            selectedAllergensData = data
        }
    }

    // helper function to load the saved selection
    private func loadSelection() {
        if let saved = try? JSONDecoder().decode([Allergen].self, from: selectedAllergensData) {
            selectedAllergens = Set(saved)
        }
    }
}


#Preview {
    NavigationView {
        ProfileView()
    }
}

