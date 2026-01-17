// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftUICoordinatorKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftUICoordinatorKit",
            targets: ["SwiftUICoordinatorKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "SwiftUICoordinatorKit"
        ),
    ]
)

