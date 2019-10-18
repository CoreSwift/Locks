// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CoreSwiftLocks",
    products: [
        .library(
            name: "CoreSwiftLocks",
            targets: ["CoreSwiftLocks"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CoreSwiftLocks",
            dependencies: [
              .target(name: "CoreSwiftCxxLock"),
            ]),
        .target(
          name: "CoreSwiftCxxLock",
          dependencies: []),
        .testTarget(
            name: "CoreSwiftLocksTests",
            dependencies: ["CoreSwiftLocks"]),
    ],
    cxxLanguageStandard: .cxx14
)
