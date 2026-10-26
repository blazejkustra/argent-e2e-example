# Argent e2e example

A small iOS shopping app with one [Argent](https://argent.swmansion.com/) e2e test that runs on every push and pull request in GitHub Actions.

- `.argent/e2e/search.yaml` is the test: launch the app, open search, type "running shoes" and check the result count.
- `.github/workflows/e2e.yml` builds the app, boots an iPhone simulator and runs the test.
- `Shop/` is the UIKit app. Every element the test touches has an `accessibilityIdentifier`.

## Run it locally

You need macOS with Xcode and Node.js.

```bash
npm install -g @swmansion/argent
xcodebuild -project Shop.xcodeproj -scheme Shop -configuration Release \
  -sdk iphonesimulator -derivedDataPath build CODE_SIGNING_ALLOWED=NO
xcrun simctl install booted build/Build/Products/Release-iphonesimulator/Shop.app
argent e2e run search --platform ios
```

The project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen). Run `xcodegen generate` after changing it.

Read the full walkthrough in the [Argent e2e tutorial](https://argent.swmansion.com/blog/argent-e2e-tutorial/).
