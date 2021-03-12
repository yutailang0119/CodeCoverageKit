// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-code-coverage-mackerel",
    products: [
        .executable(name: "code-coverage-mackerel",
                    targets: ["code-coverage-mackerel"]),
        .library(name: "CodeCoverageKit",
                 targets: ["CodeCoverageKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "code-coverage-mackerel",
            dependencies: ["CodeCoverageKit"]),
        .target(
            name: "CodeCoverageKit",
            dependencies: []),
        .testTarget(
            name: "CodeCoverageKitTests",
            dependencies: ["CodeCoverageKit"]),
    ]
)
