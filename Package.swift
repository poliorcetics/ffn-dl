// swift-tools-version:5.1

//
//  Package.swift
//
//  Created by Alexis Bourget on 2019-01-04.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import PackageDescription

let package = Package(
  name: "ffn-dl",
  products: [
    .library(name: "ffn-dl", targets: ["ffn-dl"])
  ],
  dependencies: [
    .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.0"),
  ],
  targets: [
    .target(name: "ffn-dl", dependencies: ["SwiftSoup"], path: "Sources"),
    .testTarget(name: "ffn-dlTests", dependencies: ["ffn-dl"], path: "Tests"),
  ]
)
