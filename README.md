# CustomComponents

CustomComponents is a Swift package offering a collection of reusable, production-ready SwiftUI components. Designed to accelerate iOS development, this library provides modular UI elements that seamlessly integrate into your SwiftUI projects.

## Features
- Reusable SwiftUI Components: A variety of customizable UI elements to enhance your app’s interface.
- Modular Design: Each component is self-contained, promoting clean and maintainable code.
- Swift Package Manager Support: Easily integrate into your projects using Swift Package Manager.

## Installation

You can add CustomComponents to your project using Swift Package Manager:
1. In Xcode, go to File > Add Packages…
2. Enter the repository URL: `https://github.com/stalkermv/CustomComponents`
3. Select the development branch.

Alternatively, add it directly to your Package.swift:

```
dependencies: [
    .package(url: "https://github.com/stalkermv/CustomComponents.git", branch: "development")
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

## License

CustomComponents is released under the MIT License. See LICENSE for details.
