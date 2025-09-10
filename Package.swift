// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Showcase",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Showcase",
            targets: ["Showcase"]
        ),
    ],
    targets: [
        .target(
            name: "Showcase",
            path: "Source"
        ),
        .testTarget(
            name: "ShowcaseTests",
            dependencies: ["Showcase"],
            path: "Tests/ShowcaseTests"
        ),
    ]
)
