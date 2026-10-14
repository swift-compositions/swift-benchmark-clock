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
        .package(url: "https://github.com/swift-atoms/swift-clock.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-clocks.git", branch: "main"),
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
                .product(name: "Clock", package: "swift-clock"),
                .product(name: "Formatter", package: "swift-formatter"),
            ]
        ),
        .testTarget(
            name: "Benchmark Clock Tests",
            dependencies: [
                .target(name: "Benchmark Clock"),
                .product(name: "Formatter", package: "swift-formatter"),
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(name: "Clock", package: "swift-clock"),
                .product(name: "Clocks", package: "swift-clocks"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
