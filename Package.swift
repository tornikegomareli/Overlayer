// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Overlayer",
    platforms: [
      .iOS(.v17),
      .watchOS(.v10),
      .macOS(.v15),
      .tvOS(.v15),
      .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Overlayer",
            targets: ["Overlayer"]),
    ],
    targets: [
        .target(
            name: "Overlayer"),
        .testTarget(
            name: "OverlayerTests",
            dependencies: ["Overlayer"]
        ),
    ]
)
