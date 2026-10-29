// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WOCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WOCore",
            targets: ["WOCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.8.1"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(path: "../WOResources")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WOCore",
            dependencies: [
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "WOResources", package: "WOResources"),
            ]
        ),
        .testTarget(
            name: "WOCoreTests",
            dependencies: ["WOCore"],
            path: "Tests/WOCoreTests"
        )
        
    ]
)
