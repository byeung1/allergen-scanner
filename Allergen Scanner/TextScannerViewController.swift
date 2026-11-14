//
//  TextScannerViewController.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-14.
//

import SwiftUI
import VisionKit
import Vision

struct TextScannerViewController: UIViewControllerRepresentable {
    @Binding var scannedText: String
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerVC = VNDocumentCameraViewController()
        scannerVC.delegate = context.coordinator
        return scannerVC
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: TextScannerViewController

        init(_ parent: TextScannerViewController) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var fullText = ""
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                for observation in observations {
                    if let best = observation.topCandidates(1).first {
                        fullText += best.string + "\n"
                    }
                }
                DispatchQueue.main.async {
                    self.parent.scannedText = fullText
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
            request.recognitionLevel = .accurate

            DispatchQueue.global(qos: .userInitiated).async {
                for i in 0..<scan.pageCount {
                    let image = scan.imageOfPage(at: i)
                    if let cgImage = image.cgImage {
                        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                        try? handler.perform([request])
                    }
                }
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Scan failed: \(error.localizedDescription)")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
