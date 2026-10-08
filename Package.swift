// swift-tools-version: 6.3

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
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0"
        ),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 5.3:macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0"
        ),
        .enableExperimentalFeature(
            "AvailabilityMacro=SwiftStdlib 6.2:macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0"
        ),
        .treatAllWarnings(as: .error),
    ]
}
