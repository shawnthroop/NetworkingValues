// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkingValues",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "NetworkingValues",
            targets: ["NetworkingValues"]),
    ],
    targets: [
        .target(
            name: "NetworkingValues",
            dependencies: []),
//        .testTarget(
//            name: "NetworkingValuesTests",
//            dependencies: ["NetworkingValues"]),
    ]
)
