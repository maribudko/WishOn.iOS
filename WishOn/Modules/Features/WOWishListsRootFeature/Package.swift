// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WOWishListsRootFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WOWishListsRootFeature",
            targets: ["WOWishListsRootFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(path: "../../Core/WODesign"),
        .package(path: "../../Core/WOCore"),
        .package(path: "../../Core/WOResources"),
        .package(path: "../../Core/WONewWishListFeature"),
        .package(path: "../../Core/WOToGiveFeature"),
        .package(path: "../../Core/DependencyInjection")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WOWishListsRootFeature",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "WODesign", package: "WODesign"),
                .product(name: "WOCore", package: "WOCore"),
                .product(name: "WOResources", package: "WOResources"),
                .product(name: "WONewWishListFeature", package: "WONewWishListFeature"),
                .product(name: "WOToGiveFeature", package: "WOToGiveFeature"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
            ]
        ),
        .testTarget(
            name: "WOWishListsRootFeatureTests",
            dependencies: ["WOWishListsRootFeature"]
        ),
    ]
)
