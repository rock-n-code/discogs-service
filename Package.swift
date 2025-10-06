// swift-tools-version: 5.10

// ===----------------------------------------------------------------------===
// 
// This source file is part of the DiscogsService open source project
// 
// Copyright (c) 2025 Röck+Cöde VoF. and the DiscogsService project authors
// Licensed under Apache license v2.0
// 
// See LICENSE for license information
// See CONTRIBUTORS for the list of DiscogsService project authors
//
// SPDX-License-Identifier: Apache-2.0
// 
// ===----------------------------------------------------------------------===

import PackageDescription

let package = Package(
    name: DiscogsService.package,
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .visionOS(.v1),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: DiscogsService.package,
            targets: [DiscogsService.target]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(
            name: DiscogsService.target,
            path: "Sources/\(DiscogsService.target)"
        ),
        .testTarget(
            name: DiscogsService.test,
            dependencies: [
                .byName(name: DiscogsService.target)
            ],
            path: "Tests/\(DiscogsService.target)"
        ),
    ]
)

// MARK: - Constants

enum DiscogsService {
    static let package = "discogs-service"
    static let target = "DiscogsService"
    static let test = "\(DiscogsService.target)Tests"
}
