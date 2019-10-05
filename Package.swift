// swift-tools-version:5.0

/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import PackageDescription

let package = Package(
    name: "AETransition",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AETransition",
            targets: ["AETransition"]
        )
    ],
    targets: [
        .target(
            name: "AETransition"
        )
    ]
)
