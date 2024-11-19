// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TwoFa", // Defines the package name as TwoFa
    platforms: [
        .macOS(.v15), // macOS 14 and later
        .iOS(.v18) // iOS 17 and later
    ], // Specifies the platforms supported by the package
    products: [
        .library(
            name: "TwoFa",
            targets: ["TwoFa"]) // Defines the library product with the target TwoFa
    ], // Lists the products of the package
    dependencies: [
        // .package(url: "https://github.com/sentryco/Logger.git", branch: "main"), // Adds Logger as a dependency
        .package(url: "https://github.com/sentryco/MockGen.git", branch: "main") // Adds MockGen as a dependency
    ], // Lists the dependencies of the package
    targets: [
        .target(
            name: "TwoFa",
            dependencies: [/*"Logger", */"MockGen"]), // Adds Logger and MockGen as dependencies for the TwoFa target
        .testTarget(
            name: "TwoFaTests",
            dependencies: ["TwoFa"]) // Defines the TwoFaTests target with a dependency on TwoFa
    ] // Lists the targets of the package
)
