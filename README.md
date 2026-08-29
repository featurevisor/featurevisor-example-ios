# featurevisor-example-ios

A small SwiftUI application showing how to use the [Featurevisor Swift SDK](https://github.com/featurevisor/featurevisor-swift2).

Learn more about Featurevisor [here](https://featurevisor.com).

The application evaluates the same flag, variation, feature variables, and global variables as the other Featurevisor SDK examples.

## Requirements

You need Xcode 16 or newer. The application targets iOS 14 or newer.

## Run the application

1. Open `FeaturevisorExampleIOS.xcodeproj` in Xcode.
2. Wait for Swift Package Manager to resolve the Featurevisor dependency.
3. Select an iPhone simulator.
4. Run the `FeaturevisorExampleIOS` scheme.

The application uses this production datafile:

```text
https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-sdk-v3.json
```

The direct SDK integration lives in `FeaturevisorViewModel.swift`. Change its context values to see how Featurevisor selects different rules, variations, and global variable overrides.

## Checks

```sh
xcodebuild \
  -project FeaturevisorExampleIOS.xcodeproj \
  -scheme FeaturevisorExampleIOS \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Learn more in the [Featurevisor Swift SDK documentation](https://featurevisor.com/docs/sdks/swift/).
