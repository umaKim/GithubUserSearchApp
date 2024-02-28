// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubUserSearchApp",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "PresentationLayer", targets: ["PresentationLayer"]),
        .library(name: "DomainLayer", targets: ["DomainLayer"]),
        .library(name: "DataLayer", targets: ["DataLayer"]),
       
        .library(name: "DependencyInjectionManager", targets: ["DependencyInjectionManager"])
    ],
    targets: [
        .target(name: "PresentationLayer", dependencies: ["DomainLayer"]),
        .target(name: "DomainLayer", dependencies: []),
        .target(name: "DataLayer", dependencies: ["DomainLayer"]),
        
        .target(name: "DependencyInjectionManager", dependencies: ["PresentationLayer", "DomainLayer", "DataLayer"]),
        
        .testTarget(
            name: "GithubUserSearchAppTests",
            dependencies: ["PresentationLayer", "DomainLayer"]
        ),
    ]
)
