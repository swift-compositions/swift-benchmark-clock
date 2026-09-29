// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-benchmark-clock",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Benchmark Clock", targets: ["Benchmark Clock"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-benchmark.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-clock-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-cardinal-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-formatter.git",
            branch: "main",
            traits: ["Time", "Number"]
        ),
    ],
    targets: [
        .target(
            name: "Benchmark Clock",
            dependencies: [
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(name: "Clock Primitives", package: "swift-clock-primitives"),
                .product(name: "Formatter", package: "swift-formatter"),
            ]
        ),
        .testTarget(
            name: "Benchmark Clock Tests",
            dependencies: [
                .target(name: "Benchmark Clock"),
                .product(name: "Formatter", package: "swift-formatter"),
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(
                    name: "Cardinal Primitives Standard Library Integration",
                    package: "swift-cardinal-primitives"
                ),
                .product(name: "Clock Primitives", package: "swift-clock-primitives"),
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
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
