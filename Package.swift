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
    targets: [
        .target(
            name: "SwiftUICoordinatorKit"
        ),
    ]
)

