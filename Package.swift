// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeCoverageMackerelKit",
    products: [
        .executable(name: "code-coverage-mackerel",
                    targets: ["code-coverage-mackerel"]),
        .library(name: "CodeCoverageMackerelKit",
                 targets: ["CodeCoverageMackerelKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "code-coverage-mackerel",
            dependencies: ["CodeCoverageMackerelKit"]),
        .target(
            name: "CodeCoverageMackerelKit",
            dependencies: []),
        .testTarget(
            name: "CodeCoverageMackerelKitTests",
            dependencies: ["CodeCoverageMackerelKit"]),
    ]
)
