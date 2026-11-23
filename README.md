# CustomComponents

CustomComponents is a Swift package offering a collection of reusable, production-ready SwiftUI components. Designed to accelerate iOS development, this library provides modular UI elements that seamlessly integrate into your SwiftUI projects.

## Features
- Reusable SwiftUI Components: A variety of customizable UI elements to enhance your app’s interface.
- Modular Design: Each component is self-contained, promoting clean and maintainable code.
- Swift Package Manager Support: Easily integrate into your projects using Swift Package Manager.

## Requirements

- Swift 6.1 or later
- iOS 17, macOS 14, tvOS 17, or watchOS 10 and later
- `CustomStepper` is not available on tvOS

## Installation

You can add CustomComponents to your project using Swift Package Manager:
1. In Xcode, go to File > Add Packages…
2. Enter the repository URL: `https://github.com/stalkermv/CustomComponents`
3. Choose the version you need.

Alternatively, add it directly to your Package.swift. 2.0 is currently a pre-release, so the requirement has to name it; `from: "2.0.0"` does not resolve pre-releases:

```
dependencies: [
    .package(url: "https://github.com/stalkermv/CustomComponents.git", from: "2.0.0-beta.3")
]
```

## Usage

Import CustomComponents in your SwiftUI files:

```swift
import CustomComponents
```

Then, utilize the provided components as needed. For example:

```swift
struct ContentView: View {
    var body: some View {
        CustomCell {
            Text("Hello, Custom Component!")
        }
    }
}
```

### Capping a scrolling block

```swift
CommandOutput(lines)
    .scrollHeightLimit(300, pinsToBottom: true)
```

The view is as tall as its content until 300 points, then scrolls inside itself. `ScrollViewThatFits(maxHeight:)` is the same as a view. On iOS 18, macOS 15, tvOS 18 and watchOS 11 and later the edges that can still scroll fade out; `scrollEdgeFade(_:)` turns that off.

### Parsing text fields

```swift
CustomTextField(value: $amount, format: .currency(code: "USD"))
    .parseBehavior(.lenient.debounced(.milliseconds(300)))
```

`.strict` (default) rewrites the text to the formatted output on every keystroke. `.lenient` keeps what the user typed.

## License

CustomComponents is released under the MIT License. See LICENSE for details.
