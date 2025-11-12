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
      url: "https://github.com/compilet-dev/ios-compilet-sdk/releases/download/1.0.0/CompiletSDK.xcframework.zip",
      checksum: "9479831b414bd4355af70912cf9b6f668eac9fe001d43fc30ced7f4f02820657"
    )
  ]
)
