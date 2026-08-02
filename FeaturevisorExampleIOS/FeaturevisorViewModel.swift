import Combine
import Featurevisor
import Foundation

@MainActor
final class FeaturevisorViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var enabled = false
    @Published private(set) var variation = ""
    @Published private(set) var welcomeMessage = ""

    private let datafileURL = URL(
        string: "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-mobile.json"
    )!
    private var f: Featurevisor?

    func load() {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: datafileURL) { [weak self] data, response, error in
            guard let self else {
                return
            }

            if let error {
                Task { @MainActor in
                    self.showError(error.localizedDescription)
                }
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode),
                let data
            else {
                Task { @MainActor in
                    self.showError("The datafile request failed.")
                }
                return
            }

            do {
                let datafile = try DatafileContent.fromData(data)
                let f = createFeaturevisor(
                    FeaturevisorOptions(datafile: datafile)
                )
                let context: Context = [
                    "userId": .string("mobile-user"),
                    "country": .string("nl")
                ]

                let enabled = f.isEnabled("mobile_experience", context)
                let variation = f.getVariation("mobile_experience", context) ?? "none"
                let welcomeMessage = f.getVariableString(
                    "mobile_experience",
                    "welcome_message",
                    context
                ) ?? "none"

                Task { @MainActor in
                    self.f?.close()
                    self.f = f
                    self.enabled = enabled
                    self.variation = variation
                    self.welcomeMessage = welcomeMessage
                    self.isLoading = false
                }
            } catch {
                Task { @MainActor in
                    self.showError("Could not parse the Featurevisor datafile.")
                }
            }
        }.resume()
    }

    private func showError(_ message: String) {
        isLoading = false
        errorMessage = message
    }
}
