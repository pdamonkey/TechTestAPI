// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "API",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "API", targets: ["API"]),
    ],
    targets: [
        .target(
            name: "API",
            resources: [
                .process("MockData/schedule.json")
            ]
        ),
        .testTarget(name: "APITests", dependencies: ["API"]),
    ]
)
