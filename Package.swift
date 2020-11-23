// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CountNumberPicker",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v11)
    ],
    products: [
        .library(
            name: "CountNumberPicker",
            targets: ["CountNumberPicker"]
        ),
    ],
    targets: [
        .target(
            name: "CountNumberPicker",
            dependencies: []
        )
    ]
)
