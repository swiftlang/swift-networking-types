// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-networking-types",
    products: [
        .library(
            name: "NetworkingTypes",
            targets: ["NetworkingTypes"]
        )
    ],
    targets: [
        .target(
            name: "NetworkingTypes",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
        .testTarget(
            name: "NetworkingTypesTests",
            dependencies: ["NetworkingTypes"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
    ]
)
