// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DependencyInjection",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DependencyInjection",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
            ]
        ),
        
    ]
)
