// swift-tools-version:4.2

/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import PackageDescription

let package = Package(
    name: "AETransition",
    products: [
        .library(name: "AETransition", targets: ["AETransition"])
    ],
    targets: [
        .target(
            name: "AETransition"
        )
    ]
)
