// swift-tools-version: 5.10

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
    dependencies: [],
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
