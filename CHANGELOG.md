# Changelog

All notable changes to this project are documented in this file.

## 2.0.0-beta.1 - 2026-11-23

### Breaking

- Minimum deployments are now iOS 17, macOS 14, Mac Catalyst 17, tvOS 17 and watchOS 10 (previously iOS 16 and tvOS 15).
- Depends on SwiftUIBackports 2.0, which removes the backports that native iOS 17 APIs replace.

### Fixed

- `CustomContentUnavailableView` no longer fails to build on macOS with recent SDKs. The default style uses `ContentUnavailableView` directly now that every supported OS ships it.

### Known issues

- The package does not build for tvOS and watchOS yet: SwiftUIHelpers 1.1.8 does not compile on those platforms. This is expected to be fixed by a SwiftUIHelpers update in a later beta.
