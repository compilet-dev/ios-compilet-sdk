// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "CompiletSDK",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "CompiletSDK",
      targets: ["CompiletSDK"]
    )
  ],
  targets: [
    .binaryTarget(
      name: "CompiletSDK",
      url: "https://github.com/compilet-dev/ios-compilet-sdk/releases/download/0.1.0/CompiletSDK.xcframework.zip",
      checksum: "849026814e0b770cfa5c141a3df2e44140a706395c95ec7eb3bf9678c4b853b2"
    )
  ]
)
