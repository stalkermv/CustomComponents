# Changelog

All notable changes to this project are documented in this file.

## 2.0.0-beta.2 - 2026-11-23

### Breaking

- `CustomStepper` and its styles are not available on tvOS, where SwiftUI has no `Stepper`.

### Changed

- Depends on SwiftUIHelpers 2.0 (`from: "2.0.0-beta.1"`).

### Fixed

- The package builds for tvOS and watchOS. Preview-only code that used `Material.bar` (not available on tvOS and watchOS) and `.pickerStyle(.segmented)` (not available on watchOS) is guarded for those platforms.

## 2.0.0-beta.1 - 2026-11-23

### Breaking

- Minimum deployments are now iOS 17, macOS 14, Mac Catalyst 17, tvOS 17 and watchOS 10 (previously iOS 16 and tvOS 15).
- Depends on SwiftUIBackports 2.0, which removes the backports that native iOS 17 APIs replace.

### Fixed

- `CustomContentUnavailableView` no longer fails to build on macOS with recent SDKs. The default style uses `ContentUnavailableView` directly now that every supported OS ships it.

### Known issues

- The package does not build for tvOS and watchOS yet: SwiftUIHelpers 1.1.8 does not compile on those platforms. Fixed in 2.0.0-beta.2.
