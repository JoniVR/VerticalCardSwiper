// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "VerticalCardSwiper",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "VerticalCardSwiper", targets: ["VerticalCardSwiper"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "VerticalCardSwiper",
            dependencies: [],
            path: "Sources"
        )
    ]
)
