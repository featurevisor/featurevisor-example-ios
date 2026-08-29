import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeaturevisorViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Featurevisor for iOS")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Evaluating features and global variables with the Featurevisor Swift SDK.")
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
                        row("Maximum checkout items", viewModel.maxItems)
                        row("Payment methods", viewModel.paymentMethods)
                        row("Service endpoint", viewModel.serviceEndpoint)
                        row("Support contact", viewModel.supportContact)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding(24)
        }
        .onAppear(perform: viewModel.load)
    }

    private func row(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
