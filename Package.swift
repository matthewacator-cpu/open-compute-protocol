// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OCPDesktop",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "OCPDesktopCore", targets: ["OCPDesktopCore"]),
        .executable(name: "OCPDesktop", targets: ["OCPDesktop"])
    ],
    targets: [
        .target(name: "OCPDesktopCore"),
        .executableTarget(
            name: "OCPDesktop",
            dependencies: ["OCPDesktopCore"]
        ),
        .testTarget(
            name: "OCPDesktopCoreTests",
            dependencies: ["OCPDesktopCore"]
        )
    ]
)
