// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Component {
    static let sharedDependencies: [Target.Dependency] = [
        .product(name: "SwiftHelpers", package: "SwiftHelpers"),
        .product(name: "SwiftUIHelpers", package: "SwiftUIHelpers"),
        .product(name: "SwiftUIBackports", package: "SwiftUIBackports"),
    ]
    
    let name: String
    let dependencies: [Target.Dependency]
    
    init(name: String, dependencies: [Target.Dependency] = sharedDependencies) {
        self.name = name
        self.dependencies = dependencies
    }
}

let components: [Component] = [
    Component(name: "AsyncButton"),
    Component(name: "CustomCell"),
    Component(name: "CustomPicker"),
    Component(name: "CustomSection"),
    Component(name: "CustomStepper"),
    Component(name: "CustomTextField")
]

let package = Package(
    name: "CustomComponents",
    platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v15), .watchOS(.v10), .macCatalyst(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "CustomComponents", targets: ["CustomComponents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stalkermv/SwiftHelpers.git", from: "1.0.0"),
        .package(url: "https://github.com/stalkermv/SwiftUIHelpers.git", from: "1.0.0"),
        .package(url: "https://github.com/stalkermv/SwiftUIBackports.git", from: "1.0.0"),
    ]
)

let umbrella: Target = .target(name: "CustomComponents", dependencies: components.map { .target(name: $0.name) })
let testTarget: Target = .testTarget(name: "CustomComponentsTests", dependencies: ["CustomComponents"])
let componentsTargets: [Target] = components.map { component in
    .target(name: component.name, dependencies: component.dependencies)
}

package.targets = [umbrella, testTarget] + componentsTargets
