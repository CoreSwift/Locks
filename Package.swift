// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Locks",
    products: [
        .library(
            name: "Locks",
            targets: ["Locks"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Locks",
            dependencies: [
              .target(name: "CxxLock"),
            ]),
        .target(
          name: "CxxLock",
          dependencies: []),
        .testTarget(
            name: "LocksTests",
            dependencies: ["Locks"]),
    ],
    cxxLanguageStandard: .cxx14
)
