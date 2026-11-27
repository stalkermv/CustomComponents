# Changelog

All notable changes to this project are documented in this file.

## Unreleased

### Fixed

- The default `CustomPicker` style ignored `currentValueLabel`. It now passes it to the system `Picker`, which shows it on iOS 18, macOS 15, tvOS 18, watchOS 11 and later; earlier systems show the selected option.
- `CustomTextField` kept showing old text when the bound value changed from outside the field, such as a reset, and the next edit started from that text. The field now shows the new value and clears its error.
- With `.lenient`, a parse error was hidden on each keystroke and shown again straight away, so it never went away while typing. Without a debounce, the error now stays hidden while the field is focused and appears when it loses focus.

### Documentation

- `.disabled(true)` inside a `CustomPicker` option does not reach the picker, so the option stays selectable; use `.selectionDisabled()` on the option. Noted in the README.
- The README parsing example now uses an initializer that exists (`CustomTextField("Amount", value:format:)`), and a test keeps it compiling.

## 2.0.0-beta.5 - 2026-11-24

### Documentation

- `AsyncButton` documents that it does not draw a progress indicator and that its label or `ButtonStyle` reads the `isLoading` environment value.
- `CustomStepper` documents that inside a `Form` row you set `.buttonStyle(.plain)`, because SwiftUI gives one tap to every button in the row.
- README notes for both, and for the `CustomCell` image column width, which is decided in `CustomCellStyle`.

## 2.0.0-beta.4 - 2026-11-24

### Added

- `import CustomComponents` now re-exports every component module (`AsyncButton`, `CustomCell`, `CustomContentUnavailableView`, `CustomPicker`, `CustomSection`, `CustomStepper` except on tvOS, `CustomTextField`, `DynamicScroll`), so one import exposes all types. The modules can still be imported one by one.
- A test target that only does `import CustomComponents` and uses a type from each module.

## 2.0.0-beta.3 - 2026-11-23

### Added

- `DynamicScroll`: `ScrollViewThatFits` is a scroll view exactly as tall as its content until a ceiling, after which it scrolls inside itself. Scrolling is off while the content fits, and the bottom can stay pinned while content grows. `scrollHeightLimit(_:axes:pinsToBottom:)` is the same thing as a modifier on any view.
- `ScrollEdgeFade` and `scrollEdgeFade(_:)`, `scrollEdgeFade(edges:)`, `scrollEdgeFade(_:)` (Bool) soften the edges that can still be scrolled towards. The ceiling, scroll gesture and pinned bottom work on every supported system; the fade is drawn on iOS 18, macOS 15, tvOS 18, watchOS 11 and visionOS 2 and later and is ignored on earlier systems.
- `CustomPicker`: initializers with a `currentValueLabel` (single and multiple selection), `CustomPickerConfiguration.currentValueLabel`, and the selected trait for accessibility on selected options.
- `CustomTextField`: `ParseBehavior` with `.strict` (default, the 1.0.7 behaviour), `.lenient`, `debounced(_:)` and `hidesErrorOnInput(_:)`, set with `parseBehavior(_:)`.

### Behaviour changes

- `CustomPicker`: an option inside a disabled subtree is now reported as disabled to its item style, not only options marked with `selectionDisabled`.
- `CustomPicker`: an option without a tag is reported as disabled, because it cannot be chosen.
- `CustomTextField` in lenient mode keeps the last valid value when the text stops parsing, instead of clearing it. Strict mode still clears it.
- `CustomTextField` shows the formatted text when it first appears in raw mode.

### Changed

- Depends on SwiftUIHelpers `from: "2.0.0-beta.2"`.

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
