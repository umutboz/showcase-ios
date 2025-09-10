// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ShowCase",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ShowCase",
            targets: ["ShowCase"]
        ),
    ],
    targets: [
        .target(
            name: "Showcase",
            path: "Source"
        ),
        .testTarget(
            name: "ShowcaseTests",
            dependencies: ["ShowCase"],
            path: "Tests/ShowcaseTests"
        ),
    ]
)
