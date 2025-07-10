// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WOLoginFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WOLoginFeature",
            targets: ["WOLoginFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.8.1"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "8.0.0"),
        .package(path: "../../Core/WODesign"),
        .package(path: "../../Core/WOResources"),
        .package(path: "../../Core/DependencyInjection"),
        .package(path: "../WOWishListsRootFeature"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WOLoginFeature",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "WODesign", package: "WODesign"),
                .product(name: "WOResources", package: "WOResources"),
                .product(name: "WOWishListsRootFeature", package: "WOWishListsRootFeature"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
            ]
        ),
        .testTarget(
            name: "WOLoginFeatureTests",
            dependencies: ["WOLoginFeature"]
        ),
    ]
)
