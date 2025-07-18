// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WONewWishListFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WONewWishListFeature",
            targets: ["WONewWishListFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(path: "../../Core/WODesign"),
        .package(path: "../../Core/WOResources"),
        .package(path: "../../Core/DependencyInjection"),
        .package(path: "../WOAddNewItemFeature")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WONewWishListFeature",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "WODesign", package: "WODesign"),
                .product(name: "WOResources", package: "WOResources"),
                .product(name: "WOAddNewItemFeature", package: "WOAddNewItemFeature"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
            ]
        ),
        .testTarget(
            name: "WONewWishListFeatureTests",
            dependencies: ["WONewWishListFeature"]
        ),
    ]
)
