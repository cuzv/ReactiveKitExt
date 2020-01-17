// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveKitExt",
    platforms: [
        .macOS(.v10_11), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ReactiveKitExt",
            targets: ["ReactiveKitExt"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/DeclarativeHub/ReactiveKit",
            .upToNextMajor(from: "3.15.6")
        ),
        .package(
            url: "https://github.com/cuzv/ResultConvertible",
            .branch("master")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ReactiveKitExt",
            dependencies: ["ReactiveKit", "ResultConvertible"],
            path: "Sources"
        ),
        .testTarget(
            name: "ReactiveKitExtTests",
            dependencies: ["ReactiveKitExt"]
        ),
    ]
)