# featurevisor-example-ios

A small SwiftUI application showing how to use the [Featurevisor Swift SDK](https://github.com/featurevisor/featurevisor-swift2).

The application downloads a Featurevisor datafile, creates an SDK instance, and evaluates the `mobile_experience` feature as a flag, variation, and string variable.

## Requirements

You need Xcode 16 or newer. The application targets iOS 14 or newer.

## Run the application

1. Open `FeaturevisorExampleIOS.xcodeproj` in Xcode.
2. Wait for Swift Package Manager to resolve the Featurevisor dependency.
3. Select an iPhone simulator.
4. Run the `FeaturevisorExampleIOS` scheme.

## Featurevisor usage

The application fetches this production datafile:

```text
https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-mobile.json
```

The important SDK usage is in `FeaturevisorViewModel.swift`:

```swift
let datafile = try DatafileContent.fromData(data)
let featurevisor = createFeaturevisor(
    FeaturevisorOptions(datafile: datafile)
)

let context: Context = [
    "userId": .string("mobile-user"),
    "country": .string("nl")
]

let enabled = featurevisor.isEnabled("mobile_experience", context)
let variation = featurevisor.getVariation("mobile_experience", context)
let message = featurevisor.getVariableString(
    "mobile_experience",
    "welcome_message",
    context
)
```

Learn more in the [Featurevisor Swift SDK documentation](https://featurevisor.com/docs/sdks/swift/).
