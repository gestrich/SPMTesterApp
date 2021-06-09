// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "Binary Frameworks",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Stripe",
            targets: ["Stripe"])

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        
        .binaryTarget(name: "Stripe",
                      url: "https://github.com/stripe/stripe-ios/releases/download/v19.3.0/Stripe.xcframework.zip",
                      checksum: "fe459dd443beee5140018388fd6933e09b8787d5b473ec9c2234d75ff0d968bd"),
    ]
)

