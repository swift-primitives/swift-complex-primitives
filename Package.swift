// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-complex-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "Complex Primitives", targets: ["Complex Primitives"]),
        .library(
            name: "Complex Primitives Test Support",
            targets: ["Complex Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-numeric-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-dimension-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Complex Primitives",
            dependencies: [
                .product(name: "Real Primitives", package: "swift-numeric-primitives"),
                .product(name: "Numeric Relaxed Primitives", package: "swift-numeric-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
            ]
        ),
        .target(
            name: "Complex Primitives Test Support",
            dependencies: [
                "Complex Primitives",
                .product(name: "Tagged Primitives Test Support", package: "swift-tagged-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Complex Primitives Tests",
            dependencies: [
                "Complex Primitives",
                .product(name: "Tagged Primitives Standard Library Integration", package: "swift-tagged-primitives"),
                "Complex Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
