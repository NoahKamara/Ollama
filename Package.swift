// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ollama",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Ollama",
            targets: ["Ollama"]
        )
    ],
    dependencies: [.package(path: "../SwiftChain")],
    targets: [
        .target(
            name: "Ollama"
        ),
        .testTarget(
            name: "OllamaTests",
            dependencies: ["Ollama"]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    // -enable-bare-slash-regex becomes
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    // -warn-concurrency becomes
    .enableUpcomingFeature("StrictConcurrency"),
        .unsafeFlags(["-enable-actor-data-race-checks"],
            .when(configuration: .debug)),
]

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: swiftSettings)
}
