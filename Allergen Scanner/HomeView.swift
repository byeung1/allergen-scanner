import SwiftUI

// This struct is what the user sees when they open up the app
// It is considered the "base" of the app
// The user accessess everything from this view
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Allergen Scanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Button to navigate to the ProfileView
                NavigationLink(destination: ProfileView()) {
                    Label("Edit Allergen Profile", systemImage: "person.crop.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Button to navigate to the ScannerView
                NavigationLink(destination: ScannerView()) {
                    Label("Scan / Paste Ingredients", systemImage: "doc.text.magnifyingglass")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
