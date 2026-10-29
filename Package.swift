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
            swiftSettings: swiftSettings,
        ),
        .testTarget(
            name: "NetworkingTypesTests",
            dependencies: ["NetworkingTypes"],
            swiftSettings: swiftSettings,
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .swiftLanguageMode(.v6),
        .strictMemorySafety(),
        .enableUpcomingFeature("ApproachableConcurrency"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("ExistentialAny"),
        .treatAllWarnings(as: .error),
    ]
}
