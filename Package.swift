// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-numeric-complex-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "Complex Primitives", targets: ["Complex Primitives"]),
    ],
    dependencies: [
        .package(path: "../swift-numeric-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(path: "../swift-test-primitives"),
    ],
    targets: [
        .target(
            name: "Complex Primitives",
            dependencies: [
                .product(name: "Real Primitives", package: "swift-numeric-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
            ]
        ),
        .testTarget(
            name: "Complex Primitives Tests",
            dependencies: [
                "Complex Primitives",
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
}
