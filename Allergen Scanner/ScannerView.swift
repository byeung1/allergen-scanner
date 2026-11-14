//
//  ScannerView.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-14.
//

import SwiftUI
// Supplies the OCR types used in the recognizeTextFromImage() function
import Vision
// Imports Apple's document-scanning framework
import VisionKit
// Imports the photo-picker framework
import PhotosUI

// Helper function to hide keyboard when tapping outside
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ScannerView: View {
    @AppStorage("selectedAllergens") var selectedAllergensData: Data = Data()
    // String for the user's manually typed text
    @State private var inputText: String = ""
    @State private var detectedAllergens: [String] = []
    @State private var hasChecked = false

    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Paste or type ingredients, or scan a label:")
                    .font(.headline)

                Button {
                    showCamera = true
                } label: {
                    Label("Scan Label", systemImage: "camera.viewfinder")
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .orange))

                Button {
                    showPhotoPicker = true
                } label: {
                    Label("Import Photo", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .purple))

                ZStack(alignment: .topLeading) {
                    if inputText.isEmpty {
                        Text("e.g. Ingredients: sugar, whey protein, milk powder")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 5)
                            .padding(.top, 8)
                    }

                    TextEditor(text: $inputText)
                        .frame(height: 200)
                        .opacity(inputText.isEmpty ? 0.85 : 1)
                }
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .onChange(of: inputText) { _ in
                    hasChecked = false
                    detectedAllergens = []
                }

                Button("Check for Allergens") {
                    hideKeyboard()
                    detectedAllergens = findAllergens(in: inputText)
                    hasChecked = true
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue))

                if hasChecked {
                    if !detectedAllergens.isEmpty {
                        Text("Allergens Found:")
                            .font(.headline)
                            .foregroundColor(.red)

                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(detectedAllergens, id: \.self) {
                                Text("• \($0.capitalized)")
                            }
                        }
                    } else {
                        Text("No allergens found.")
                            .foregroundColor(.green)
                    }
                }

                Spacer()
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationTitle("Allergen Scanner")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCamera) {
            TextScannerViewController(scannedText: $inputText)
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(image: $selectedImage)
                .onChange(of: selectedImage) { _ in
                    recognizeTextFromImage()
                }
        }
    }

    func findAllergens(in text: String) -> [String] {
        let lowercasedText = text.lowercased()
        let selectedAllergens = (try? JSONDecoder().decode([Allergen].self, from: selectedAllergensData)) ?? []

        var foundAllergens: Set<String> = []

        for allergen in selectedAllergens {
            for keyword in allergen.keywords {
                if lowercasedText.contains(keyword.lowercased()) {
                    foundAllergens.insert(allergen.name)
                    break
                }
            }
        }

        return Array(foundAllergens).sorted()
    }

    func recognizeTextFromImage() {
        guard let image = selectedImage,
              let cgImage = image.cgImage else { return }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            let text = observations.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")

            DispatchQueue.main.async {
                inputText = text
            }
        }

        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}

#Preview {
    NavigationView {
        ScannerView()
    }
}
