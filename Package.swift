// swift-tools-version:4.2
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
    .target(name: "ffn-dl", dependencies: ["SwiftSoup"]),
    .target(name: "ffn-dlTests", dependencies: ["ffn-dl"]),
  ]
)
