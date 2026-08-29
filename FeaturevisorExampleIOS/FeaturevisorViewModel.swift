import Combine
import Featurevisor
import Foundation

@MainActor
final class FeaturevisorViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var enabled = false
    @Published private(set) var variation = ""
    @Published private(set) var maxItems = ""
    @Published private(set) var paymentMethods = ""
    @Published private(set) var serviceEndpoint = ""
    @Published private(set) var supportContact = ""

    private let datafileURL = URL(
        string: "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-sdk-v3.json"
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
                    FeaturevisorOptions(
                        datafile: datafile,
                        context: [
                            "userId": .string("customer-123"),
                            "country": .string("nl"),
                            "locale": .string("nl-NL"),
                            "accountPlan": .string("pro")
                        ],
                        logLevel: .error
                    )
                )

                let enabled = f.isEnabled("commerce_platform")
                let variation = f.getVariation("checkout_experience") ?? "none"
                let maxItems = f.getVariableInteger(
                    "checkout_experience",
                    "max_items"
                ).map(String.init) ?? "none"
                let paymentMethods = f.getVariableArray(
                    "checkout_experience",
                    "payment_methods"
                )?.compactMap { $0.asString() }.joined(separator: ", ") ?? "none"
                let endpoints = f.getVariableObject("serviceEndpoints")
                let serviceEndpoint = endpoints?["baseUrl"]?.asString() ?? "none"
                let supportContact = f.getVariableString("supportContact") ?? "none"

                Task { @MainActor in
                    self.f?.close()
                    self.f = f
                    self.enabled = enabled
                    self.variation = variation
                    self.maxItems = maxItems
                    self.paymentMethods = paymentMethods
                    self.serviceEndpoint = serviceEndpoint
                    self.supportContact = supportContact
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
