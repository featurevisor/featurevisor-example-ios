import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeaturevisorViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Featurevisor for iOS")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Evaluating mobile_experience with the Featurevisor Swift SDK.")
                .foregroundColor(.secondary)

            if viewModel.isLoading {
                ProgressView("Loading datafile…")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)

                Button("Try again", action: viewModel.load)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    row("Flag", viewModel.enabled ? "Enabled" : "Disabled")
                    row("Variation", viewModel.variation)
                    row("Welcome message", viewModel.welcomeMessage)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding(24)
        .onAppear(perform: viewModel.load)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
